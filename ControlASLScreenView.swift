//
//  ControlASLScreenView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/1/25.
//

import SwiftUI

struct ControlASLScreenView: View { //controls which view is displayed
    @StateObject var appModel = AppModel()
    @State var currentHandSignPredictionView: Int = 0
    
    var body: some View {
        ZStack {
            if currentHandSignPredictionView == 0 {
                StartASLInterpreterView(currentHandSignPredictionView: $currentHandSignPredictionView)
                
            }
            else {
                HandSignPredictionView(currentHandSignPredictionView: $currentHandSignPredictionView)
                    .environmentObject(appModel)
            }
        }
        .animation(.easeInOut, value: currentHandSignPredictionView)
        //.onDisappear {
        //    currentHandSignPredictionView = 0
        //}
        
    }
    
}
