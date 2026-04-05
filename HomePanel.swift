//
//  HomePanel.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/28/25.
//

import SwiftUI

struct HomePanel: View {
    
    @Binding var currentPage: Int
    
    var body: some View {
        ScrollView {
            HStack {
                TitleView(title: "SpeechLink")
            }
            .padding()
            .padding(.bottom, 50)
            
            // Calculate relative image width here
            
            // Buttons
            Button(action: {
                currentPage = 1
            }) {
                HomeButtonView(title: "View Transcripts",
                               systemImage: "text.page",
                               text: "Listen to and view your past transcripts in real time",
                               width: 50)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            
            Button(action: {
                currentPage = 2
            }) {
                HomeButtonView(title: "Help",
                               systemImage: "questionmark.circle",
                               text: "Troubleshoot any problems & learn how the app works",
                               width: 50)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            
            Button(action: {
                currentPage = 3
            }) {
                HomeButtonView(title: "Explore",
                               systemImage: "magnifyingglass",
                               text: "A brief, informative tour of this app's features",
                               width: 50)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
        }
    }
}

