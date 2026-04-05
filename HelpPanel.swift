//
//  HelpPanel.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct HelpPanel: View {
    @Binding var currentCategory: Int
    var body: some View {
        List {
            
            Button(action: {
                currentCategory = 1
            }, label: {
                HelpButtonView(text: "Audio Transcription")
            })
            Button(action: {
                currentCategory = 2
            }, label: {
                HelpButtonView(text: "Sign Language Interpreter")
            })
            Button(action: {
                currentCategory = 3
            }, label: {
                HelpButtonView(text: "Learn ASL")
            })
            Button(action: {
                currentCategory = 4
            }, label: {
                HelpButtonView(text: "FAQ")
            })
        }
    }
}
