//
//  StartASLInterpreterView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/1/25.
//

import SwiftUI

struct StartASLInterpreterView: View {
    
    @Binding var currentHandSignPredictionView: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "camera")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            TitleView(title: "Live ASL Interpreter")
            Button(action: {
                currentHandSignPredictionView = 1
            }) {
                RegularButtonView(text: "Start Interpreting")
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
            Spacer()
        }
        
    }
    
}
