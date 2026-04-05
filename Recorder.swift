//
//  Recorder.swift
//  TrialApp
//
//  Created by Aarav Agarwal on 7/7/25.
//

import Foundation
import AVFoundation
import SwiftUI

class Recorder {
    private var outputContinuation: AsyncStream<AVAudioPCMBuffer>.Continuation? = nil
    private let audioEngine: AVAudioEngine
    private let transcriber: SpokenWordTranscriber
    private let converter = BufferConverter()
    
    var currentFramePosition: AVAudioFramePosition = 0
    private var playbackStartFrame: AVAudioFramePosition = 0
    var conversation: Conversation
    var playerNode: AVAudioPlayerNode?
    var file: AVAudioFile?
    private let url: URL
    var onPlaybackEnded: (() -> Void)?

    init(transcriber: SpokenWordTranscriber, conversation: Conversation) {
        self.audioEngine = AVAudioEngine()
        self.transcriber = transcriber
        self.conversation = conversation

        self.url = conversation.persistentAudioURL

        // Attempt to load existing file (optional)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                self.file = try AVAudioFile(forReading: url)
                //print("Loaded existing audio file at \(url)")
            } catch {
                print("Failed to load existing audio file: \(error)")
                self.file = nil
            }
        } else {
            self.file = nil // Will be created on recording
        }
    }

    func record() async throws {
        //self.conversation.url = url
        
        guard await isAuthorized() else {
            print("Mic permission denied.")
            return
        }

#if os(iOS)
        try setUpAudioSession()
#endif
        try await transcriber.setUpTranscriber()

        //print("Recording started. Output file: \(url)")
        for await input in try await audioStream() {
            try await self.transcriber.streamAudioToTranscriber(input)
        }
    }

    func stopRecording() async throws {
        audioEngine.stop()
        conversation.isDone = true
        try await transcriber.finishTranscribing()

        // Ensure file handle is closed before playback
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        self.file = nil

    }

    func pauseRecording() {
        audioEngine.pause()
    }

    func resumeRecording() throws {
        try audioEngine.start()
    }

#if os(iOS)
    func setUpAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord,
                                     mode: .spokenAudio,
                                     options: [.defaultToSpeaker])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
#endif

    private func audioStream() async throws -> AsyncStream<AVAudioPCMBuffer> {
        try setupAudioEngine()

        let inputFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0,
                                         bufferSize: 4096,
                                         format: inputFormat) { [weak self] (buffer, _) in
            guard let self else { return }
            self.writeBufferToDisk(buffer: buffer)
            self.outputContinuation?.yield(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        return AsyncStream(AVAudioPCMBuffer.self, bufferingPolicy: .unbounded) { continuation in
            self.outputContinuation = continuation
        }
    }

    private func setupAudioEngine() throws {
        // WAV-compatible format
        let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16,
                                         sampleRate: 44100,
                                         channels: 1,
                                         interleaved: true)!

        self.file = try AVAudioFile(forWriting: url, settings: outputFormat.settings)
        audioEngine.inputNode.removeTap(onBus: 0) // Clear any existing taps
    }

    func playRecording() {
        do {
            self.file = try AVAudioFile(forReading: url)
        } catch {
            print("Failed to reopen audio file for playback: \(error)")
            return
        }

        guard let file else {
            print("No audio file available for playback")
            return
        }

        let totalFrames = file.length
        currentFramePosition = max(0, min(currentFramePosition, totalFrames - 1))
        playbackStartFrame = currentFramePosition

        let framesToPlay = AVAudioFrameCount(totalFrames - currentFramePosition)
        guard framesToPlay > 0 else {
            print("No frames to play. Skipping playback.")
            return
        }

        playerNode?.stop()
        if let playerNode = playerNode {
            audioEngine.disconnectNodeOutput(playerNode)
            audioEngine.detach(playerNode)
        }

        playerNode = AVAudioPlayerNode()
        guard let playerNode else { return }

        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.outputNode, format: file.processingFormat)

        // schedule playback from currentFramePosition
        playerNode.scheduleSegment(file,
                                   startingFrame: currentFramePosition,
                                   frameCount: framesToPlay,
                                   at: nil,
                                   completionCallbackType: .dataPlayedBack) { [weak self] _ in
            guard let self = self else { return }

            // Only run onPlaybackEnded if not already cleaned up
            if self.playerNode != nil {
                DispatchQueue.main.async {
                    self.onPlaybackEnded?()
                }
            }
        }

        do {
            if !audioEngine.isRunning {
                try audioEngine.start()
            }
            playerNode.play()
        } catch {
            print("Failed to start engine for playback: \(error)")
        }
    }


    func stopPlaying() {
        if let playerNode = playerNode,
           let lastRenderTime = playerNode.lastRenderTime,
           let playerTime = playerNode.playerTime(forNodeTime: lastRenderTime),
           let file = self.file {
            //let playedFrames = AVAudioFramePosition(playerTime.sampleTime)
            let newFramePos = playbackStartFrame + AVAudioFramePosition(playerTime.sampleTime)
            currentFramePosition = min(newFramePos, file.length)
        }
        playerNode?.stop()
        cleanupPlayback()
    }

    
    func pausePlayback() {
        playerNode?.pause()
    }

    func resumePlayback() {
        playerNode?.play()
    }
    
    func cleanupPlayback() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        if let playerNode = playerNode {
            playerNode.stop()
            audioEngine.disconnectNodeOutput(playerNode)
            audioEngine.detach(playerNode)
            self.playerNode = nil
        }
        
        audioEngine.reset()
        //currentFramePosition = 0
    }


}
