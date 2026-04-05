//
//  ASLQuizView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct ASLGameView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var currentASLPage: Int
    
    let wordArray = getWordArray()

    
    @State var shouldButtonShowStart: Bool = true //decides whether the button says start or new game
    @State var userClickedNewWord: Bool = false //decides when to disable the replay button
    @State var isPlaying: Bool = false //decides if the images are currently playing
    @State var shouldFlipImage: Bool = false //decides if the image should be flipped (in case of double letters)
    
    @State var userGuess: String = ""
    @State var currentWordIndex: Int = 0
    @State var currentCharacter: String = "start"
    
    @State var oldUserScore: Int = 0
    @State var userScore: Int = 0
    
    @AppStorage("highScore") var highScore: Int = 0
    @AppStorage("difficultyLevel") var difficultyLevel: Double = 2.2
    
    var body: some View {
        VStack{
            Button(action: {
                currentASLPage = 0
            }, label: {
                BackButton()
            })
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            TitleView(title: "ASL Word Game")
                .padding()
            ScrollView {
                if currentCharacter.count > 1 {
                    Text(currentCharacter == "start" ? "To start playing, click the \"Start\" button below" : currentCharacter == "guess" ? "If you think you know what the word is, enter your guess in the textbox. Otherwise, replay the clue." : currentCharacter == "guessedCorrectly" ? "Congratulations on getting the word! Click \"New Word\" below to keep going!" : oldUserScore == 1 ? "Sorry, the correct word was \"\(wordArray[currentWordIndex]).\" You scored \(oldUserScore) point. Click \"Start\" to play again!" : "Sorry, the correct word was \"\(wordArray[currentWordIndex]).\" You scored \(oldUserScore) points. Click \"Start\" to play again!")
                        .font(Font.custom("AvenirNext-Regular", size: 20))
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 350, height: 200)
                        .border(colorScheme == .dark ? .white : .black)
                }
                
                else {
                    Image(currentCharacter)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(height: 200)
                        .border(colorScheme == .dark ? .white : .black)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .scaleEffect(x: shouldFlipImage ? -1 : 1, y: 1)
                        
                }
                
                
                HStack {
                    Button(action: {
                        if shouldButtonShowStart {
                            userScore = 0
                        }
                        shouldButtonShowStart = false
                        
                        Task {
                            await startButtonClick()
                        }
                    }, label: {
                        RegularButtonView(text: shouldButtonShowStart ? "Start" : "New Word")
                    })
                    .disabled(isPlaying)
                    
                    Button(action: {
                        Task {
                            await replayButtonClick()
                        }
                    }, label: {
                        RegularButtonView(text: "Replay")
                    })
                    .disabled(isPlaying || !userClickedNewWord)
                }
                .padding()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.darkShadow)

                    TextField("Guess the word", text: $userGuess)
                        .disabled(shouldButtonShowStart || isPlaying)
                        .onSubmit {
                            let validatedGuess = validateGuess(guess: userGuess)
                            if(!validatedGuess) {
                                oldUserScore = userScore
                                currentCharacter = "guessedIncorrectly"
                                shouldButtonShowStart = true
                            }
                            else {
                                currentCharacter = "guessedCorrectly"
                            }
                            userClickedNewWord = false
                            userScore += validatedGuess ? 1 : -userScore
                            highScore = max(userScore, highScore)
                            userGuess = ""
                        }
                }
                .padding()
                .foregroundStyle(Color.neumorphictextColor)
                .background(colorScheme == .dark ? .black : .white)
                .cornerRadius(6)
                .modifier(ShadowModifier())
                .padding()
                
                VStack (alignment: .leading) {
                    Text("Stats:")
                        .font(.headline)
                    Divider()
                        .overlay(colorScheme == .dark ? .white : .black)
                    HStack {
                        Text("Current Score: \(userScore)")
                            .font(Font.custom("AvenirNext-Regular", size: 20))
                            .frame(maxWidth: .infinity, alignment: .center)
                        Divider()
                            .overlay(colorScheme == .dark ? .white : .black)
                        Text("High Score: \(highScore)")
                            .font(Font.custom("AvenirNext-Regular", size: 20))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(colorScheme == .dark ? .black : .white)
                        .modifier(ShadowModifier())
                )
                .padding()
                
                VStack (alignment: .leading) {
                    Text("Difficulty:")
                        .font(.headline)
                    Divider()
                        .overlay(colorScheme == .dark ? .white : .black)
                    Slider(value: $difficultyLevel, in: 0.4...4)
                        .disabled(!shouldButtonShowStart)
                    HStack {
                        Text("Beginner")
                        Spacer()
                        Text("Pro")
                    }
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(colorScheme == .dark ? .black : .white)
                        .modifier(ShadowModifier())
                )
                .padding()
            }
        }
    }
        
    
    func startButtonClick() async {
        userClickedNewWord = true
        
        currentWordIndex = Int.random(in: 0...wordArray.count - 1)
        Task {
            await replayButtonClick()
        }
        
        
    }
    
    func replayButtonClick() async {
        isPlaying = true
        var oldCharacter = ""
        for character in wordArray[currentWordIndex] {
            currentCharacter = String(character).uppercased()
            if oldCharacter == currentCharacter {
                shouldFlipImage = true
            }
            else {
                shouldFlipImage = false
            }
            do {
                try await Task.sleep(nanoseconds: UInt64((4.4 - difficultyLevel) * 1_000_000_000))
            } catch {
                print("Task sleep was cancelled: \(error)")
            }
            oldCharacter = currentCharacter
        }
        currentCharacter = "guess"
        isPlaying = false
        
    }
    
    func validateGuess(guess: String) -> Bool {
        let filteredGuess = guess.lowercased()
        return (filteredGuess == wordArray[currentWordIndex])
    }
}
