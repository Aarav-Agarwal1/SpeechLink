//
//  OnboardingView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/8/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @State private var pageIndex = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to SpeechLink",
            description: "A free accessibility app with live speech transcription, sign language learning tools, a built-in ASL interpreter, and more",
            imageName: "hands.sparkles"
        ),
        OnboardingPage(
            title: "Live Speech Transcription",
            description: "Transcribe conversations in real time and look back on it later at any time you need to.",
            imageName: "waveform.and.mic"
        ),
        OnboardingPage(
            title: "Learn ASL",
            description: "Interactive lessons to help you go from a beginner to master in ASL fingerspelling.",
            imageName: "graduationcap"
        ),
        OnboardingPage(
            title: "ASL Interpreter",
            description: "Point your camera at someone signing and get real-time text translations, or practice your own sign language skills.",
            imageName: "camera.viewfinder"
        ),
        OnboardingPage(
            title: "Questions?",
            description: "Visit the \"Help\" page on the homepage to get answers to all your questions and learn even more about the app.",
            imageName: "questionmark.circle"
        ),
        OnboardingPage(
            title: "Let's Get Started!",
            description: "Start a new transcript, learn how to fingerspell, or play a game - all in one app!",
            imageName: "figure.run"
        )
    ]

    var body: some View {
        VStack {
            TabView(selection: $pageIndex) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Spacer()
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
                        Button(action: {
                            if pageIndex < pages.count - 1 {
                                withAnimation { pageIndex += 1 }
                            } else {
                                hasSeenOnboarding = true
                            }
                        }) {
                            Text(pageIndex == pages.count - 1 ? "Get Started" : "Next")
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
    }
}

struct PageIndicator: View {
    @Environment(\.colorScheme) var colorScheme
    var count: Int
    var currentIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index != currentIndex ? Color.gray.opacity(0.4) : colorScheme == .dark ? .white : .black)
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView()
}

