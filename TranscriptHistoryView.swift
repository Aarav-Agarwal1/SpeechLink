//
//  TranscriptHistoryView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/28/25.
//

import SwiftUI
import SwiftData

struct TranscriptHistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext

    @Binding var currentPage: Int
    @Binding var selectedTab: Int

    @Query var conversations: [Conversation]
    
    @State private var showEditPopup = false
    @State private var editingConversation: Conversation?
    @State private var editedTitle: String = ""

    var body: some View {
        NavigationStack {
            Button(action: {
                currentPage = 0
            }) {
                BackButton()
            }
            TitleView(title: "Conversations")
            if conversations.isEmpty {
                ScrollView {
                    ContentUnavailableView("No Conversations", systemImage: "text.bubble", description: Text("Start a new conversation by clicking the button below!"))
                        .frame(maxWidth: .infinity)
                    
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(colorScheme == .dark ? .black : .white)
                                .modifier(ShadowModifier())
                        )
                        .padding()
                        .padding(.top)
                    Button(action: {
                        selectedTab = 1
                    }, label: {
                        RegularButtonView(text: "Start a Conversation")
                        
                    })
                    .padding(.horizontal)
                }
            }
            else {
                List {
                    ForEach(conversations) { conversation in
                        
                        NavigationLink(value: conversation) {
                            VStack(alignment: .leading) {
                                Text(conversation.title)
                                    .font(.headline)
                                Text(String(conversation.text.characters.prefix(60)))
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                
                            }
                            .padding(.vertical, 4)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                editingConversation = conversation
                                editedTitle = conversation.title
                                showEditPopup = true
                                
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                            
                            Button(role: .destructive) {
                                deleteItem(conversation)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        
                        
                    }
                }
                .navigationDestination(for: Conversation.self) { convo in
                    TranscriptView(conversation: convo)
                }
            }
            
        }
        .overlay {
            if showEditPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showEditPopup = false
                        }

                    VStack(spacing: 20) {
                        Text("Edit Title")
                            .font(.headline)

                        TextField("Enter new title", text: $editedTitle)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)

                        HStack {
                            Button("Cancel") {
                                showEditPopup = false
                            }
                            .foregroundColor(.red)

                            Spacer()

                            Button("Save") {
                                if let convo = editingConversation {
                                    updateConversation(convo, editedTitle)
                                }
                                showEditPopup = false
                            }
                            .disabled(editedTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
                    .frame(maxWidth: 300)
                    .shadow(radius: 10)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showEditPopup)
            }
        }
        
    }
    
    func deleteItem (_ item: Conversation) {
        modelContext.delete(item)
    }
    
    func updateConversation (_ conversation: Conversation,_ newTitle: String) {
        conversation.title = newTitle
        try? modelContext.save()
    }
}


