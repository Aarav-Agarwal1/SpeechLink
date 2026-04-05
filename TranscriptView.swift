//
//  TranscriptView.swift
//  TrialApp
//
//  Created by Aarav Agarwal on 7/7/25.
//

import SwiftUI
import SwiftData
import AVFoundation
import Speech

struct TranscriptView: View {
    @Bindable var conversation: Conversation
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme

    @State var isRecording = false
    @State var isPlaying = false

    @State var recorder: Recorder
    @State var speechTranscriber: SpokenWordTranscriber
    @State var currentPlaybackTime = 0.0
    @State var timer: Timer?

    init(conversation: Conversation) {
        self.conversation = conversation
        let transcriber = SpokenWordTranscriber(conversation: conversation)
        recorder = Recorder(transcriber: transcriber, conversation: conversation)
        speechTranscriber = transcriber
    }


    var body: some View {
        VStack {
            TitleView(title: conversation.title)
            if !conversation.isDone {
                Group {
                    liveRecordingView
                }
                Spacer()
                Button(action: {
                    handleRecordingButtonTap()
                }, label: {
                    HStack {
                        Image(systemName: isRecording ? "stop" : "play")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(isRecording ? "Stop" : "Record")
                            //.font(Font.custom("AvenirNext-Regular", size: 50))
                    }
                    .font(Font.custom("Copperplate", size: 50))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                })
                .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
            else {
                Group {
                    playbackView
                }
                Button(action: {
                    //pause/resume
                    handlePlayButtonTap()
                }, label: {
                    HStack {
                        Image(systemName: isPlaying ? "pause.fill" : "play")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(isPlaying ? "Pause" : "Play")
                            //.font(Font.custom("AvenirNext-Regular", size: 50))
                    }
                    .font(Font.custom("Copperplate", size: 50))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                })
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                

            }
            
            
        }
        .padding(20)
        .onChange(of: isRecording) { _, newValue in
            Task {
                if newValue {
                    try? await recorder.record()
                } else {
                    try? await recorder.stopRecording()
                    try? modelContext.save()
                }
            }
        }
        .onChange(of: isPlaying) { _, _ in
            handlePlayback()
        }
        .onAppear {
            recorder.onPlaybackEnded = {
                print("Playback finished. Resetting recorder.")
                DispatchQueue.main.async {
                    self.isPlaying = false
                    self.timer?.invalidate()
                    self.timer = nil

                    // cleaning up the playback
                    self.recorder.cleanupPlayback()
                    self.currentPlaybackTime = Double(self.recorder.currentFramePosition) / (self.recorder.file?.processingFormat.sampleRate ?? 44100)
                }
            }

        }
        
        .onDisappear {
            if conversation.text == "" {
                //for demo:
                //conversation.text = "Hey. How are you doing?\nI'm great. What about you?\nI'm a bit stressed about our presentation. Did you finish your slide?\nYeah, I finished it yesterday.\nSounds good, see you in class on Monday!\nSee you then!"
                modelContext.delete(conversation)
            }
            //stopping recording/playback when users leave the tab
            if isRecording { handleRecordingButtonTap() }
            if isPlaying { handlePlayButtonTap() }
            dismiss()
        }

    }

    @ViewBuilder
    var liveRecordingView: some View {
        Text(speechTranscriber.finalizedTranscript + speechTranscriber.volatileTranscript)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    var playbackView: some View {
        textScrollView(attributedString: conversation.conversationBrokenUpByLines(), currentPlaybackTime: currentPlaybackTime)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension TranscriptView {//functions for TranscriptView.swift
    
    func handlePlayback() {
        let url = conversation.persistentAudioURL

        if isPlaying {
            if recorder.playerNode != nil {
                recorder.resumePlayback()
            }
            else {
                recorder.playRecording()
            }

            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                DispatchQueue.main.async {
                    guard let playerNode = recorder.playerNode,
                          let lastRenderTime = playerNode.lastRenderTime,
                          
                          let playerTime = playerNode.playerTime(forNodeTime: lastRenderTime),
                          let audioFile = try? AVAudioFile(forReading: url) else {
                        self.currentPlaybackTime = 0.0
                        return
                    }

                    let currentTime = Double(playerTime.sampleTime) / playerTime.sampleRate
                    let duration = Double(audioFile.length) / audioFile.processingFormat.sampleRate

                    if currentTime >= duration {
                        self.recorder.stopPlaying()
                        self.currentPlaybackTime = 0.0
                        self.isPlaying = false
                        self.timer?.invalidate()
                        self.timer = nil
                    } else {
                        self.currentPlaybackTime = currentTime
                    }
                }
            }


        } else {
            recorder.pausePlayback()
            timer?.invalidate()
            timer = nil
        }
    }
    
    func handleRecordingButtonTap() {
        isRecording.toggle()
    }
    
    func handlePlayButtonTap() {
        isPlaying.toggle()
    }
    
    func attributedStringWithCurrentValueHighlighted(attributedString: AttributedString) -> AttributedString {
        var copy = attributedString
        copy.runs.forEach { run in
            if shouldBeHighlighted(attributedStringRun: run) {
                let range = run.range
                copy[range].backgroundColor = .mint.opacity(0.2)
            }
        }
        return copy
    }

    func shouldBeHighlighted(attributedStringRun: AttributedString.Runs.Run, currentPlaybackTime: Double) -> Bool {
        guard isPlaying else { return false }
        guard let start = attributedStringRun.audioTimeRange?.start.seconds,
              let end = attributedStringRun.audioTimeRange?.end.seconds else {
            return false
        }
        return (start <= currentPlaybackTime && currentPlaybackTime < end)
    }
    
    func shouldBeHighlighted(attributedStringRun: AttributedString.Runs.Run) -> Bool {
        guard isPlaying else { return false }
        guard let start = attributedStringRun.audioTimeRange?.start.seconds,
              let end = attributedStringRun.audioTimeRange?.end.seconds else {
            return false
        }
        return (start <= currentPlaybackTime && currentPlaybackTime < end)
    }

    
    @ViewBuilder
    func textScrollView(attributedString: AttributedString, currentPlaybackTime: Double) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                textWithHighlighting(attributedString: attributedString)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func textWithHighlighting(attributedString: AttributedString) -> some View {
        Text(attributedStringWithCurrentValueHighlighted(attributedString: attributedString))
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
}
