//
//  ChatbotView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/28/25.
//

import SwiftUI

struct ExploreView: View {
    
    @Binding var currentPage: Int
    @Binding var selectedTab: Int
    
    @State private var pageIndex = 0

    let pages: [ExplorePage] = [
        ExplorePage(
            title: "Welcome to the Explore tour!",
            description: "Discover what makes SpeechLink unique. You can click the buttons below to exit or visit the pages in the tour at any time.",
            imageName: "figure.wave",
            page: 0
        ),
        ExplorePage(
            title: "Live Speech Transcription View",
            description: "Whenever you want to transcribe anything, you can visit the Transcribe page and get real-time high quality speech transcription.",
            imageName: "microphone.fill",
            page: 1
        ),
        ExplorePage(
            title: "View Transcripts",
            description: "This is where you can find your old conversations, replay them, delete them, or edit them.",
            imageName: "book.pages",
            page: 0
        ),
        ExplorePage(
            title: "ASL Interpreter",
            description: "Point your camera at someone fingerspelling ASL, and the app will translate it for you. You can also use this view to practice your own fingerspelling.",
            imageName: "camera.viewfinder",
            page: 2
        ),
        ExplorePage(
            title: "Learn ASL",
            description: "This is the page where you can go from a complete beginner to a master at fingerspelling. See the following pages for more info.",
            imageName: "graduationcap",
            page: 3
        ),
        ExplorePage(
            title: "ASL Resources",
            description: "This page has flashcards and a chart of the letters that you can glance at any time you want to refresh your memory.",
            imageName: "rectangle.stack",
            page: 3
        ),
        ExplorePage(
            title: "ASL Game",
            description: "If you want to get better at recognizing sign language, then go to our game page, adjust difficulty, get new high scores, and improve your recognition.",
            imageName: "gamecontroller",
            page: 3
        ),
        ExplorePage(
            title: "ASL Lessons",
            description: "This page is designed to help you learn ASL from the ground up, teaching you letters in small groups and measuring your accuracy.",
            imageName: "book.closed",
            page: 3
        ),
        ExplorePage(
            title: "Help",
            description: "Any time you have any doubts or want any clarification, the help page has everything you need to know about SpeechLink.",
            imageName: "questionmark.circle",
            page: 0
        ),
        ExplorePage(
            title: "Have fun!",
            description: "Thank you for finishing the tour, and be sure to have fun using all the features in this app!",
            imageName: "sparkles",
            page: 0
        )
    ]

    var body: some View {
        VStack {
            TabView(selection: $pageIndex) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        HStack {
                            Button(action: {
                                currentPage = 0
                            }, label: {
                                BackButton()
                            })
                            Spacer()
                        }
                        Image(systemName: pages[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.accentColor)

                        Text(pages[index].title)
                            .font(Font.custom("ComicSansMS", size: 40))
                            .multilineTextAlignment(.center)

                        Text(pages[index].description)
                            .font(Font.custom("AvenirNext-Regular", size: 25))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Spacer()
                        if pageIndex != pages.count - 1  && index != 0 {
                            Button(action: {
                                if pages[index].page != 0 {
                                    selectedTab = pages[index].page
                                }
                                else {
                                    currentPage = 0
                                }
                            }) {
                                Text("Visit")
                                    .font(Font.custom("Copperplate", size: 30))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                        Button(action: {
                            if pageIndex < pages.count - 1 {
                                withAnimation { pageIndex += 1 }
                            } else {
                                currentPage = 0
                            }
                        }) {
                            Text(pageIndex == pages.count - 1 ? "Exit" : "Next")
                                .font(Font.custom("Copperplate", size: 30))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        Spacer(minLength: 20)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            PageIndicator(count: pages.count, currentIndex: pageIndex)
                    .padding(.bottom, 16)
        }
        .onDisappear {
            currentPage = 0
        }
    }
}

struct ExplorePage {
    let title: String
    let description: String
    let imageName: String
    let page: Int
}

