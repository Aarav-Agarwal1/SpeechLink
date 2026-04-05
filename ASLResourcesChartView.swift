//
//  ASLOverviewChatView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/3/25.
//

import SwiftUI

struct ASLResourcesChartView: View {
    var letterArray: Array<ASLLetter>
    var body: some View {
        ScrollView {
            TitleView(title: "ASL Alphabet Chart")
            VStack(spacing: 0) {
                ForEach(0..<7) { bigNumber in
                    HStack(spacing: 0) {
                        ForEach(0..<4) { smallNumber in
                            let letterNumber = smallNumber + (bigNumber * 4)
                            if letterNumber < 27 {
                                LetterChartView(letter: letterArray[letterNumber].letter)
                            }
                            
                            
                        }
                    }
                }
            }
            
        }
    }
}

struct LetterChartView: View {
    @Environment(\.colorScheme) var colorScheme
    var letter: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(letter)
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                .font(.title)
                .padding()
            Image(letter)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
        }
        
        .frame(maxWidth: .infinity, alignment: .center)
        .border(colorScheme == .dark ? .white : .black)
    }
}

