//
//  FAQHelpView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct FAQHelpView: View {
    @Binding var currentCategory: Int
    var body: some View {
        VStack {
            Button(action: {
                currentCategory = 0
            }, label: {
                BackButton()
            })
            TitleView(title: "Frequently Asked Questions")
            ScrollView {
                FAQView(question: "Why isn't my camera/mic working?", answer: "When you first download the app, the app will prompt you to give it access when you go to a page that uses one of the two. If they are still not working, try restarting your device. For more info on how we use these technologies, refer to our Privacy Policy.")
                
                FAQView(question: "How do I edit or delete my transcripts?", answer: "Navigate to the Transcript History and swipe left on the transcript. You will see options to delete or edit the title of your transcripts.")
                
                FAQView(question: "How do I save my transcripts?", answer: "The app automatically saves all of your transcripts, so you don't need to do anything. Simply stop the recording, and all of your previous transcripts will appear (unless you delete them).")
                
                FAQView(question: "Where can I find more information about this app's features and capabilities?", answer: "You can find more information on our website or on our other help pages.")
                
                FAQView(question: "Why are none of my hand gestures being picked up by the interpreter?", answer: "Ensure that you are in an area with good lighting, are not too far from the camera, and are making the right gesture. For more info, see our help page on the Interpreter.")
                
                FAQView(question: "How are the lessons structured?", answer: "Each lesson covers 5 to 6 symbols at once with flashcards and questions to help you learn each letter. This ensures that there are not too many lessons and not too much content in each lesson, allowing you to learn the alphabet quickly.")
            }
            
            
        }
    }
}
