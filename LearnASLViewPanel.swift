//
//  LearnASLView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/28/25.
//

import SwiftUI

struct LearnASLViewPanel: View {
    @Binding var currentASLPage: Int
    var body: some View {
        ScrollView {
            TitleView(title: "Learn ASL")
                .padding()
                .padding(.bottom, 50)
            
            
            Button(action: {
                currentASLPage = 1
            }) {
                HomeButtonView(title: "Lessons", systemImage: "square.and.pencil", text: "Learn the full ASL alphabet step-by-step", width: 50)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            
            Button(action: {
                currentASLPage = 2
            }) {
                HomeButtonView(title: "Play Game", systemImage: "dice", text: "Test your understanding of the letters in an interactive way", width: 50)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            
            Button(action: {
                currentASLPage = 3
            }) {
                HomeButtonView(title: "ASL Resources", systemImage: "book.closed", text: "All the resources you need to master the ASL alphabet", width: 50)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            
            
        }
    }
    
}
