//
//  HelpView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/28/25.
//

import SwiftUI

struct HelpView: View {
    
    @Binding var currentPage: Int
    @State var currentCategory: Int = 0
    
    var body: some View {
        if currentCategory == 0 {
            VStack {
                Button(action: {
                    currentPage = 0
                }, label: {
                    BackButton()
                })
                TitleView(title: "Help")
                
                HelpPanel(currentCategory: $currentCategory)
                
                
            }
        }
        
        else if currentCategory == 1 {
            AudioTranscriptionHelpView(currentCategory: $currentCategory)
        }
        
        else if currentCategory == 2 {
            SignLanguageInterpreterHelpView(currentCategory: $currentCategory)
        }
        
        else if currentCategory == 3 {
            LearnASLHelpView(currentCategory: $currentCategory)
        }
        
        else if currentCategory == 4 {
            FAQHelpView(currentCategory: $currentCategory)
        }
    }
}











