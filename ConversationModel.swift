//
//  ConversationModel.swift
//  TrialApp
//
//  Created by Aarav Agarwal on 7/7/25.
//

import Foundation
import AVFoundation
import SwiftData

@Model
class Conversation: Identifiable {
    typealias StartTime = CMTime

    @Attribute(.unique) var id: UUID
    var title: String
    @Attribute(.externalStorage) private var archivedText: Data
    var isDone: Bool

    var text: AttributedString {
        get { Self.unarchive(archivedText) ?? AttributedString("") }
        set { archivedText = Self.archive(newValue) }
    }

    init(title: String, text: AttributedString, isDone: Bool = false) {
        self.title = title
        self.archivedText = Self.archive(text)
        self.isDone = isDone
        self.id = UUID()
    }

    private static func archive(_ value: AttributedString) -> Data {
        let ns = NSAttributedString(value)
        return (try? NSKeyedArchiver.archivedData(withRootObject: ns, requiringSecureCoding: true)) ?? Data()
    }

    private static func unarchive(_ data: Data) -> AttributedString? {
        guard let ns = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data) else {
            return nil
        }
        return AttributedString(ns)
    }
}

extension Conversation {
    static func blank(number: Int) -> Conversation {
        return .init(title: "Conversation \(number)", text: AttributedString(""))
    }

    func conversationBrokenUpByLines() -> AttributedString {
        //guard url != nil else {
        //    print("url was nil")
        //    return text
        //}

        var final = AttributedString("")
        var working = AttributedString("")
        let copy = text

        copy.runs.forEach { run in
            let runText = copy[run.range].characters
            if runText.contains(".") {
                working.append(copy[run.range])
                final.append(working)
                final.append(AttributedString("\n\n"))
                working = AttributedString("")
            } else {
                if working.characters.isEmpty {
                    let trimmed = runText.trimmingPrefix(" ")
                    let newAttributed = AttributedString(trimmed, attributes: run.attributes)
                    working.append(newAttributed)
                } else {
                    working.append(copy[run.range])
                }
            }
        }

        return final.characters.isEmpty ? working : final
    }
}

extension Conversation {
    var persistentAudioURL: URL {
        let filename = "conversation_\(id.uuidString).wav"
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!

        // Ensure directory exists
        let audioDir = base.appendingPathComponent("Audio")
        try? FileManager.default.createDirectory(at: audioDir, withIntermediateDirectories: true)

        return audioDir.appendingPathComponent(filename)
    }
}
