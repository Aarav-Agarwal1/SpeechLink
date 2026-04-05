//
//  ASLPracticeView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct ASLLessonsView: View {
    @Binding var currentASLPage: Int
    var letterArray: [ASLLetter]
    
    @AppStorage("lessonCompletion") private var lessonCompletionData: Data = Data()
    @AppStorage("totalQuestionsData") private var totalQuestionsData: Data = Data()
    @AppStorage("correctQuestionsData") private var correctQuestionsData: Data = Data()

    private var totalQuestionsPerLesson: [Int] {
        get {
            (try? JSONDecoder().decode([Int].self, from: totalQuestionsData)) ?? Array(repeating: 0, count: lessons.count)
        }
        set {
            totalQuestionsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    private var correctQuestionsPerLesson: [Int] {
        get {
            (try? JSONDecoder().decode([Int].self, from: correctQuestionsData)) ?? Array(repeating: 0, count: lessons.count)
        }
        set {
            correctQuestionsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    private func getTotalQuestionsArray() -> [Int] {
        (try? JSONDecoder().decode([Int].self, from: totalQuestionsData)) ?? Array(repeating: 0, count: lessons.count)
    }
    
    private func getCorrectQuestionsArray() -> [Int] {
        (try? JSONDecoder().decode([Int].self, from: correctQuestionsData)) ?? Array(repeating: 0, count: lessons.count)
    }
    
    private func saveTotalQuestionsArray(_ array: [Int]) {
        totalQuestionsData = (try? JSONEncoder().encode(array)) ?? Data()
    }
    
    private func saveCorrectQuestionsArray(_ array: [Int]) {
        correctQuestionsData = (try? JSONEncoder().encode(array)) ?? Data()
    }
    
    private var lessonCompletion: [Bool] {
        get {
            (try? JSONDecoder().decode([Bool].self, from: lessonCompletionData)) ?? Array(repeating: false, count: lessons.count)
        }
        set {
            lessonCompletionData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    
    // all the lessons in one place
    private let lessons: [(name: String, letters: [String], description: String)] = [
        ("A-F", ["A", "B", "C", "D", "E", "F"], "Learn how to sign the starting letters of the alphabet"),
        ("G-K", ["G", "H", "I", "J", "K"], "Continue learning how to sign the start of the alphabet"),
        ("L-P", ["L", "M", "N", "O", "P"], "Expand your knowledge of ASL with the letters L-P"),
        ("Q-U", ["Q", "R", "S", "T", "U"], "Inch closer to wrapping up the full ASL alphabet"),
        ("V-Z", ["V", "W", "X", "Y", "Z", "Space"], "Learn how to sign the entire alphabet, including spaces.")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    currentASLPage = 0
                }, label: {
                    BackButton()
                })
                
                TitleView(title: "ASL Lessons")
                
                ScrollView {
                    ForEach(lessons.indices, id: \.self) { index in
                        NavigationLink(
                            destination: LessonView(
                                letters: lessons[index].letters,
                                letterArray: letterArray,
                                lessonIndex: index
                            ),
                            label: {
                                LearnButtonView(
                                    lessonName: lessons[index].name,
                                    lessonNumber: index + 1,
                                    lessonDescription: lessons[index].description,
                                    lessonState: lessonCompletion[index] ? 2 : 1,
                                    accuracy: totalQuestionsPerLesson[index] == 0 ? 0 : Int(100 * correctQuestionsPerLesson[index] / totalQuestionsPerLesson[index])
                                )
                            }
                        )
                    }
                }
            }
        }
    }
}




