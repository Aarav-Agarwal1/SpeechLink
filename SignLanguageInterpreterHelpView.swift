//
//  SignLanguageInterpreterHelpView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct SignLanguageInterpreterHelpView: View {
    @Binding var currentCategory: Int
    var body: some View {
        VStack {
            Button(action: {
                currentCategory = 0
            }, label: {
                BackButton()
            })
            TitleView(title: "Sign Language Interpreter")
            ScrollView {
                SectionView(title: "How to Use the Sign Language Interpreter", content: "To use the built-in alphabet interpreter, all you have to do is navigate to the tab and start signing whatever you want to be translated. If someone else is trying to communicate with you in ASL, point the camera towards them so that the app can translate what the other person is saying. You can also use the app to practice signing letters after learning sign language from the \"Learn ASL\" tab.")
                
                SectionView(title: "The Letters \"J\" and \"Z\"", content: "The letters \"J\" and \"Z\" normally involve movement to be done. However, in this app, all you need to do is make the ending position of the letter with your hand. For the letter \"J,\" point your pinky up and your palm should face away from the camera. For the letter \"Z,\" point your index finger directly to the camera. For more information, see the full chart in the \"Learn ASL\" tab.")
                
                SectionView(title: "How to sign a space", content: "To signal a space, point your palm upward and extend your thumb and fingers upward naturally. For more information, see the image below.")
                
                SectionView(title: "Camera Not Working", content: "You need to grant the app access to use your camera in order to use the interpreter. If the camera is not working at all, try restarting your phone or redownloading the app.")
                
                SectionView(title: "Troubleshooting", content: "If the app is not translating what you sign in the way you expect, verify that you are signing the letter correctly. If you are still experiencing difficulties, try moving closer to the camera or moving to an area with better lighting.")
                
                SectionView(title: "Controls", content: "There are buttons that allow you to clear all text and undo the last letter that was written down. To flip your camera, use the button in the top left of the screen.")
                
            }
        }
        
        
    }
}
