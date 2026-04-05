//
//  LearnASLHelpView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct LearnASLHelpView: View {
    @Binding var currentCategory: Int
    var body: some View {
        VStack {
            Button(action: {
                currentCategory = 0
            }, label: {
                BackButton()
            })
            TitleView(title: "Learn ASL")
            ScrollView {
                SectionView(title: "How to Use the Learn ASL Page", content: "This page teaches you the fundamentals of ASL fingerspelling, including the letters and the spaces to help you communicate with other people better. You can learn the alphabet and practice fingerspelling with the built-in ASL Interpreter")
                SectionView(title: "ASL Resources", content: "This page contains the resources SpeechLink uses to teach you ASL. It has flashcards that you can review with search capabilities to help you find what you want. There is also a chart that puts all the symbols in one place.")
                SectionView(title: "ASL Game", content: "This page has a game that you can play once you learn all the letters. Once you start the game, a series of images spelling a word will pop up, and your goal is to correctly identify them and enter what word they spell. You can adjust the difficulty of the game by sliding the Difficulty Level slider left or right.")
                SectionView(title: "ASL Lessons", content: "This page has lessons carefully curated to help you master all of the alphabet. When you start a lesson, you will see the flashcards with the letters that the lesson covers, and then there will be a section where you can learn to identify images based off letters and identify letters based off images.")
                SectionView(title: "Saving Lesson/Game Progress", content: "You do not need to do anything to save your high score in the ASL game or to save what lessons you completed and your accuracy, as the app automatically does that.")
            }
        }
        
        
    }
}
