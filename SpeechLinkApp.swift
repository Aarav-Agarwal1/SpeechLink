//
//  SpeechLinkApp.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/24/25.
//

import SwiftUI
import SwiftData

@main
struct SpeechLinkApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    //for testing, uncomment following lines to make user see onboarding every time they open it
    //init () {
    //    hasSeenOnboarding = false
    //}
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
            }
            else {
                OnboardingView()
            }
                
        }
        .modelContainer(for: Conversation.self)
    }
}
