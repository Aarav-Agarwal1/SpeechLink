//
//  TranscribeView.swift
//  TrialApp
//
//  Created by Aarav Agarwal on 7/8/25.
//

import SwiftUI
import SwiftData

struct TranscribeView: View {
    @State private var currentConversation: Conversation?
    @State private var isTranscribing = false

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Image(systemName: "microphone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                TitleView(title: "Live Speech Transcription")
                
                Button(action: {
                    let descriptor = FetchDescriptor<Conversation>()
                    let existingConversations = (try? modelContext.fetch(descriptor)) ?? []
                    let number = existingConversations.count + 1
                    let newConversation = Conversation.blank(number: number)
                    modelContext.insert(newConversation)
                    currentConversation = newConversation
                    isTranscribing = true
                }) {
                    RegularButtonView(text: "Start a Conversation")
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
            }
            .navigationDestination(isPresented: $isTranscribing) {
                if let convo = currentConversation {
                    TranscriptView(conversation: convo)
                }
            }
        }
    }
}
