//
//  ContentView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: 0) {
                HomeView(selectedTab: $selectedTab)
            }
            Tab("Transcribe", systemImage: "mic.fill", value: 1) {
                TranscribeView()
            }
            Tab("ASL Interpreter", systemImage: "hand.wave", value: 2) {
                ControlASLScreenView()
            }
            Tab("Learn ASL", systemImage: "graduationcap", value: 3) {
                LearnASLControlView()
                    
            }
        }
    }
}

#Preview {
    ContentView()
}
