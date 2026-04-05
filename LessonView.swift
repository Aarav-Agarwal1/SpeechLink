//
//  LessonView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/6/25.
//

import SwiftUI

struct LessonView: View {
    //environment variables
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    //shared variables
    var letters: Array<String>
    var letterArray: Array<ASLLetter>
    var lessonIndex: Int
    
    @State private var totalQuestions: Int = 0
    @State private var correctQuestions: Int = 0
    
    //variables for lesson (the initial flashcards)
    @State var currentLetter = ""
    @State var currentIndex = 0
    @State var startingIndex = 0
    
    //variables for the lesson where it asks which image the letter is
    @State private var selectedIndex: Int? = nil
    @State var quizQuestions: [[String]] = [[""]]
    @State var currentRepitition: Int = 0 //what question the user is on
    @State var didUserGuessCorrectly: Int = 0 //0 means they havent guessed, 1 means wrong, 2 means correct
    @State var shouldShowFeedbackPanel: Bool = false
    
    //variables for the lesson where it asks which letter the image is
    @State var currentQuestion: Int = 0
    @State var quizTwoQuestions: [[String]] = [[""]]
    @State var didUserClickCorrectly: Int = 0
    @State var shouldShowResultsPanel: Bool = false
    
    @AppStorage("lessonCompletion") private var lessonCompletionData: Data = Data()
    @AppStorage("totalQuestionsData") private var totalQuestionsData: Data = Data()
    @AppStorage("correctQuestionsData") private var correctQuestionsData: Data = Data()
    

    private var totalQuestionsPerLesson: [Int] {
        get {
            (try? JSONDecoder().decode([Int].self, from: totalQuestionsData)) ?? Array(repeating: 0, count: 5)
        }
        set {
            totalQuestionsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    private var correctQuestionsPerLesson: [Int] {
        get {
            (try? JSONDecoder().decode([Int].self, from: correctQuestionsData)) ?? Array(repeating: 0, count: 5)
        }
        set {
            correctQuestionsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    
    private var lessonCompletion: [Bool] {
        get {
            (try? JSONDecoder().decode([Bool].self, from: lessonCompletionData)) ?? Array(repeating: false, count: 5)
        }
        set {
            lessonCompletionData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    private func getTotalQuestionsArray() -> [Int] {
        (try? JSONDecoder().decode([Int].self, from: totalQuestionsData)) ?? Array(repeating: 0, count: 5)
    }

    private func getCorrectQuestionsArray() -> [Int] {
        (try? JSONDecoder().decode([Int].self, from: correctQuestionsData)) ?? Array(repeating: 0, count: 5)
    }

    private func saveTotalQuestionsArray(_ array: [Int]) {
        totalQuestionsData = (try? JSONEncoder().encode(array)) ?? Data()
    }

    private func saveCorrectQuestionsArray(_ array: [Int]) {
        correctQuestionsData = (try? JSONEncoder().encode(array)) ?? Data()
    }
    
    var body: some View {
        TitleView(title: "Lesson \(lessonIndex + 1)")
        
        Group {
            if currentIndex - startingIndex < letters.count {
                flashcardSection
            }
            else if currentRepitition < quizQuestions.count {
                quizOneSection
            }
            else if currentQuestion < quizTwoQuestions.count {
                quizTwoSection
            }
            else {
                endLesson
            }
        }
        .onAppear {
            quizQuestions = makeQuizQuestion()
            quizTwoQuestions = makeQuizTwoQuestion()
        }
        
        
    }
    
    private var flashcardSection: some View {
        ScrollView {
            if startingIndex == currentIndex {
                Text("These are the letters that are covered in this lesson. Take your time to examine each of the \(letters.count) letters, and when you are ready, click on \"Next Letter.\" It's okay if you don't get them all right away.")
                    .font(Font.custom("AvenirNext-Regular", size: 20))
                    .padding()
            }
            FlashcardView(letter: letterArray[currentIndex].letter, description: letterArray[currentIndex].description)
                .padding(.horizontal)
                .padding(.top)
            HStack {
                if startingIndex != currentIndex {
                    Button(action: {
                        currentIndex -= 1
                    }, label: {
                        RegularButtonView(text: "Back")
                    })
                }
                Button(action: {
                    currentIndex += 1
                }, label: {
                    RegularButtonView(text: currentIndex - startingIndex + 1 == letters.count ? "Review" : "Next")
                })
                
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
            
        }
        .onAppear {
            currentLetter = letters[0]
            if let index = letterArray.firstIndex(where: { $0.letter == currentLetter }) {
                currentIndex = index
                startingIndex = currentIndex
            }
            else {
                print("Letter not found.")
            }
        }
    }
    
    private var quizOneSection: some View {
        ScrollViewReader { proxy in
            ScrollView {
                if currentRepitition >= letters.count { //if more elements have been added to the array then before it means they got something wrong
                    HStack {
                        Image(systemName: "repeat.circle.fill")
                        Text("Previous Mistake")
                            .font(Font.custom("Copperplate", size: 20))
                        Spacer()
                    }
                    .foregroundStyle(.orange)
                    .padding()
                }
                
                Text(quizQuestions[currentRepitition][0] != "Space" ? "Which of the following images represents the letter \(quizQuestions[currentRepitition][0])?" : "Which of the following images represent the symbol for a space?")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                ForEach(0..<2) { row in
                    HStack {
                        ForEach(0..<2) { col in
                            let index = row * 2 + col + 1
                            if index < quizQuestions[currentRepitition].count {
                                quizOptionButton(for: index)
                            }
                        }
                    }
                }
                
                if shouldShowFeedbackPanel {
                    feedbackPanel(false, didUserGuessCorrectly == 1 ? false : true)
                        .id("feedback-panel")
                        .onAppear {
                            withAnimation {
                                proxy.scrollTo("feedback-panel", anchor: .bottom)
                            }
                        }
                }
            }
            .onChange(of: didUserGuessCorrectly) {
                if didUserGuessCorrectly == 1 {
                    quizQuestions.append(quizQuestions[currentRepitition])
                }
                if didUserGuessCorrectly != 0 {
                    shouldShowFeedbackPanel = true
                }
            }
        }
        .onAppear {
            //quizQuestions = makeQuizQuestion()
            print(quizQuestions)
        }
    }
    
    private var quizTwoSection: some View {
        ScrollViewReader { proxy in
            if currentQuestion >= letters.count { //if more elements have been added to the array then before it means they got something wrong
                HStack {
                    Image(systemName: "repeat.circle.fill")
                    Text("Previous Mistake")
                        .font(Font.custom("Copperplate", size: 20))
                    Spacer()
                }
                .foregroundStyle(.orange)
                .padding()
            }
            ScrollView {
                Text("What letter corresponds to this image?")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                
                ImageView(imageName: quizTwoQuestions[currentQuestion][0])
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(colorScheme == .dark ? .black : .white)
                            .modifier(ShadowModifier())
                    )
                    .padding()
                
                HStack {
                    ForEach(1..<5) { column in
                        if column < quizTwoQuestions[currentQuestion].count {
                            Button(action: {
                                didUserClickCorrectly = evaluateUserGuess(quizTwoQuestions[currentQuestion][column], quizTwoQuestions[currentQuestion][0])
                            }, label: {
                                Text(quizTwoQuestions[currentQuestion][column])
                                    .font(.headline)
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(colorScheme == .dark ? .black : .white)
                                            .modifier(ShadowModifier())
                                            
                                    )
                                    .padding(5)
                            })
                            .disabled(shouldShowResultsPanel)
                        }
                    }
                }
                if shouldShowResultsPanel {
                    feedbackPanel(true, didUserClickCorrectly == 1 ? false : true)
                        .id("feedback-panel")
                        .onAppear {
                            withAnimation {
                                proxy.scrollTo("feedback-panel", anchor: .bottom)
                            }
                        }
                }
                
            }
            .onChange(of: didUserClickCorrectly, {
                if didUserClickCorrectly == 1 {
                    quizTwoQuestions.append(quizTwoQuestions[currentQuestion])
                }
                if didUserClickCorrectly != 0 {
                    shouldShowResultsPanel = true
                }
            })
            
        }
        .onAppear {
            //quizTwoQuestions = makeQuizTwoQuestion()
            print(quizTwoQuestions)
        }
    }
    
    private var endLesson: some View {
        ScrollView {
            Text("Lesson complete!")
                .font(Font.custom("AvenirNext-Regular", size: 30))
            HStack {
                VStack {
                    Text("Questions")
                        .font(Font.custom("Copperplate", size: 20))
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                    HStack {
                        Text(String(totalQuestions))
                    }
                    .foregroundStyle(.purple)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? .black : .white)
                    )
                }
                .padding(2)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.purple)
                )
                VStack {
                    Text("Correct")
                        .font(Font.custom("Copperplate", size: 20))
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                    HStack {
                        Text(String(correctQuestions))
                    }
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? .black : .white)
                    )
                }
                .padding(2)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                )
                VStack {
                    Text("Accuracy")
                        .font(Font.custom("Copperplate", size: 20))
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                    HStack {
                        Text("\(100 * correctQuestions / totalQuestions)%")
                    }
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? .black : .white)
                    )
                }
                .padding(2)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.green)
                )
            }
            .padding()
            
            Text("Letters Learned:")
                .font(Font.custom("Copperplate", size: 30))
            
            VStack(spacing: 0) {
                ForEach(0..<2) { bigNumber in
                    HStack(spacing: 0) {
                        ForEach(0..<3) { smallNumber in
                            let letterNumber = smallNumber + (bigNumber * 3)
                            if letterNumber < letters.count {
                                LetterChartView(letter: letters[letterNumber])
                            }
                        }
                    }
                }
            }
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Continue")
                    .font(Font.custom("AvenirNext-Regular", size: 20))
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.8))
                    )
            })
            .padding()
        }
        .onAppear {
            var updated = lessonCompletion
            updated[lessonIndex] = true
            lessonCompletionData = (try? JSONEncoder().encode(updated)) ?? Data()
            totalQuestions = totalQuestionsPerLesson[lessonIndex]
            correctQuestions = correctQuestionsPerLesson[lessonIndex]
            
        }
    }
    
    //functions for the quizzes
    func getLetterDescription(letter: String) -> String {
        if let match = letterArray.first(where: { $0.letter == letter }) {
            return match.description
        } else {
            print("The letter could not be found in letterArray.")
            return ""
        }
    }
    
    func evaluateUserGuess(_ userGuess: String, _ correctAnswer: String) -> Int {
        return (userGuess == correctAnswer ? 2 : 1)
    }
    
    
    func generateQuizOptions(_ letter: String) -> Array<String> {
        let lettersOnly = letterArray.map { $0.letter }
        let filteredLetters = lettersOnly.filter { $0 != letter }
        var returnArray = [letter]
        
        let randomLetters = filteredLetters.shuffled().prefix(3)
        
        returnArray.append(contentsOf: randomLetters)
        returnArray.shuffle()
        returnArray.insert(letter, at: 0)
        
        return returnArray
    }
    
    func makeQuizTwoQuestion() -> [[String]] {
        var questionArray: [[String]] = []
        
        for letter in letters {
            let modifiedLetters = letters.filter { $0 != letter}.shuffled().prefix(3)
            var elementToAdd = [letter]
            elementToAdd.append(contentsOf: modifiedLetters)
            elementToAdd.shuffle()
            elementToAdd.insert(letter, at: 0)
            
            questionArray.append(elementToAdd)
        }
        return questionArray.shuffled()
    }
    
    func makeQuizQuestion() -> [[String]] {
        var questionArray: [[String]] = []
        
        for letter in letters {
            let elementToAdd = (generateQuizOptions(letter))
            questionArray.append(elementToAdd)
        }
        return(questionArray.shuffled())
    }
    
    @ViewBuilder
    func quizOptionButton(for index: Int) -> some View {
        
        let imageName = quizQuestions[currentRepitition][index]
        Button(action: {
            selectedIndex = index
            didUserGuessCorrectly = evaluateUserGuess(imageName, quizQuestions[currentRepitition][0])
        }, label: {
            ImageView(imageName: imageName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill((didUserGuessCorrectly != 0 && imageName == quizQuestions[currentRepitition][0]) || (selectedIndex == index && didUserGuessCorrectly == 2) ? Color.green.opacity(0.5) : selectedIndex == index && didUserGuessCorrectly == 1 ? Color.red.opacity(0.5) : colorScheme == .dark ? .black : .white)
                        .modifier(ShadowModifier())
                )
                .padding()
        })
        .disabled(didUserGuessCorrectly != 0)
    }
    
    @ViewBuilder
    func feedbackPanel(_ showCorrectAnswer: Bool, _ wasUserGuessCorrect: Bool) -> some View {
        VStack {
            HStack {
                Image(systemName: wasUserGuessCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .imageScale(.large)
                Text(wasUserGuessCorrect ? "Correct!" : "Incorrect")
                    .font(.custom("ComicSansMS", size: 20))
                    .bold()
                Spacer()
            }
            .foregroundStyle(wasUserGuessCorrect ? .green : .red)
            .padding(.bottom, 5)
            
            if showCorrectAnswer && didUserClickCorrectly == 1 {
                Text("Correct Answer: \(quizTwoQuestions[currentQuestion][0])")
                    .font(.custom("ComicSansMS", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.red)
                    .bold()
                    .padding(.bottom, 5)
            }
            
            else if !showCorrectAnswer && didUserGuessCorrectly == 1 {
                Text(getLetterDescription(letter: quizQuestions[currentRepitition][0]))
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.red)
                    .padding(.bottom, 3)
            }
            
            
            Button(action: {
                totalQuestions += 1
                correctQuestions += wasUserGuessCorrect ? 1 : 0
                
                var totalArray = getTotalQuestionsArray()
                var correctArray = getCorrectQuestionsArray()
                
                totalArray[lessonIndex] = totalQuestions
                correctArray[lessonIndex] = correctQuestions
                
                saveTotalQuestionsArray(totalArray)
                saveCorrectQuestionsArray(correctArray)
                
                if showCorrectAnswer {
                    didUserClickCorrectly = 0
                    shouldShowResultsPanel = false
                    currentQuestion += 1
                }
                else {
                    shouldShowFeedbackPanel = false
                    didUserGuessCorrectly = 0
                    currentRepitition += 1
                }
                
            }, label: {
                Text(wasUserGuessCorrect ? "Continue" : "Got it")
                    .font(Font.custom("Copperplate", size: 20))
            })
            .foregroundStyle(colorScheme == .dark ? .black : .white)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(wasUserGuessCorrect ? .green : .red)
            )
        }
        .padding()
        .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : wasUserGuessCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.2))

        .padding(.bottom)
    }
}

