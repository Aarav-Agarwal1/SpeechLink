//
//  LearnASLControlView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct LearnASLControlView: View {
    @State var currentASLPage: Int = 0
    
    var letterArray = [
        ASLLetter(letter: "A", description: "The letter \"A\" is formed by making a fist with 4 fingers and tucking your thumb on the side."),
        ASLLetter(letter: "B", description: "The letter \"B\" is formed by extending 4 fingers and tucking your thumb across your palm."),
        ASLLetter(letter: "C", description: "The letter \"C\" is formed by making a curved \"C\" shape with your fingers"),
        ASLLetter(letter: "D", description: "The letter \"D\" is formed by making a \"D\" shape with your fingers, extending your index finger up and curling the rest of your fingers."),
        ASLLetter(letter: "E", description: "The letter \"E\" is formed by curling 4 fingers and tucking your thumb underneath the fingers."),
        ASLLetter(letter: "F", description: "The letter \"F\" is formed by connecting your index and thumb while extending your other fingers."),
        ASLLetter(letter: "G", description: "The letter \"G\" is formed by pointing your index finger to the side and curling three fingers together."),
        ASLLetter(letter: "H", description: "The letter \"H\" is formed by pointing two fingers to the side and curling two fingers together."),
        ASLLetter(letter: "I", description: "The letter \"I\" is formed by pointing the pinky finger up and making a fist with the other fingers."),
        ASLLetter(letter: "J", description: "The letter \"J\" is formed with the same handshape as \"I,\" except you rotate your hand down and up to resemble the movement of \"J.\""),
        ASLLetter(letter: "K", description: "The letter \"K\" is formed by making a \"V\" shape with two fingers, curling two fingers, and extending your thumb in between the middle and index fingers."),
        ASLLetter(letter: "L", description: "The letter \"L\" is formed by making an \"L\" shape with your fingers."),
        ASLLetter(letter: "M", description: "The letter \"M\" is formed by making a fist with 4 fingers and tucking your thumb on top of the pinky finger."),
        ASLLetter(letter: "N", description: "The letter \"N\" is formed by making a fist with 4 fingers and tucking your thumb on top of the ring finger."),
        ASLLetter(letter: "O", description: "The letter \"O\" is formed by making an \"O\" shape with the fingers."),
        ASLLetter(letter: "P", description: "The letter \"P\" is formed by curling your ring and pinky, pointing your thumb and index finger forward, and pointing your middle finger down."),
        ASLLetter(letter: "Q", description: "The letter \"Q\" is formed by making a fist with 3 fingers and keeping your index and thumb parallel and facing to the side."),
        ASLLetter(letter: "R", description: "The letter \"R\" is formed by crossing yout index and middle fingers, bending your pinky and ring fingers, and putting your thumb on top of the bent fingers."),
        ASLLetter(letter: "S", description: "The letter \"S\" is formed by making a fist with 4 fingers and tucking your thumb over the index and middle fingers."),
        ASLLetter(letter: "T", description: "The letter \"T\" is formed by making a fist with 4 fingers and tucking your thumb over the middle finger."),
        ASLLetter(letter: "U", description: "The letter \"U\" is formed by pointing your index and middle fingers up and curling the other fingers."),
        ASLLetter(letter: "V", description: "The letter \"V\" is formed by making a \"V\" shape with your fingers."),
        ASLLetter(letter: "W", description: "The letter \"W\" is formed by making a \"W\" with your middle three fingers and curling the other two fingers."),
        ASLLetter(letter: "X", description: "The letter \"X\" is formed by making a fist with 4 fingers and slightly bending your index finger."),
        ASLLetter(letter: "Y", description: "The letter \"Y\" is formed by curling your middle three fingers and extending the outer fingers away from your hand."),
        ASLLetter(letter: "Z", description: "The letter \"Z\" is formed by pointing your index finger slightly up and moving your hand in a \"Z\" shape."),
        ASLLetter(letter: "Space", description: "In this app, you can add spaces between words by forming a flat handshape with fingers extended.")
    ]
    
    var body: some View {
        ZStack {
            if currentASLPage == 0 {
                LearnASLViewPanel(currentASLPage: $currentASLPage)
            }
            
            else if currentASLPage == 1 {
                ASLLessonsView(currentASLPage: $currentASLPage, letterArray: letterArray)
            }
            
            else if currentASLPage == 2 {
                ASLGameView(currentASLPage: $currentASLPage)
            }
            
            else {
                ASLResourcesView(currentASLPage: $currentASLPage, letterArray: letterArray)
                
            }
            
        }
        
    }
    
}

#Preview {
    LearnASLControlView()
}
