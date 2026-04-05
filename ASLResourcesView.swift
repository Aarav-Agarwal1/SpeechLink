//
//  ASLOverviewView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct ASLResourcesView: View {
    
    @Binding var currentASLPage: Int
    
    var letterArray: Array<ASLLetter>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                Button(action: {
                    currentASLPage = 0
                }, label: {
                    BackButton()
                })
                TitleView(title: "ASL Resources")
                    .padding(.bottom, 50)
                
                NavigationLink(destination: ASLResourcesChartView(letterArray: letterArray), label: {
                    HomeButtonView(title: "Chart", systemImage: "character.book.closed", text: "A brief overview of every letter in the ASL alphabet", width: 50)
                })
                .padding(.horizontal)
                .padding(.vertical, 7)
                
                NavigationLink(destination: ASLResourcesFlashcardView(letterArray: letterArray), label: {
                    HomeButtonView(title: "Flashcards", systemImage: "rectangle.stack", text: "Flashcards for every letter to help you learn each sign", width: 50)
                })
                .padding(.horizontal)
                .padding(.vertical, 7)
                
            }
        }
        
        
    }
}
