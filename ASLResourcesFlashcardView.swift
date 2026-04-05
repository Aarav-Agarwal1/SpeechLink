//
//  ASLOverviewFlashcardView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/3/25.
//

import SwiftUI

struct ASLResourcesFlashcardView: View {
    @Environment(\.colorScheme) var colorScheme
    var letterArray: Array<ASLLetter>
    
    @State var currentIndex = 0
    @State private var searchText = ""
    
    @FocusState private var isSearching: Bool

    var body: some View {
        ScrollView {
            TitleView(title: "ASL Alphabet Flashcards")
                .padding()
                .padding(.bottom, 50)
            HStack {
                NeumorphicStyleTextField(
                    text: $searchText,
                    imageName: "magnifyingglass",
                    onValidInput: { letter in
                        if let index = letterArray.firstIndex(where: { $0.letter == letter }) {
                            currentIndex = index
                        }
                    }
                )
            }
            .padding()
            
            FlashcardView(letter: letterArray[currentIndex].letter, description: letterArray[currentIndex].description)
                .padding(.horizontal)
            HStack {
                Button(action: {
                    currentIndex = currentIndex == 0 ? 26 : currentIndex - 1
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 27, height: 20)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                })
                
                Spacer()
                Button(action: {
                    currentIndex = currentIndex == 26 ? 0 : currentIndex + 1
                }, label: {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 27, height: 20)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                })
                
            }
            .padding()
            .padding(.horizontal)
             
        }
    }
}

struct NeumorphicStyleTextField: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var text: String
    var imageName: String
    var onValidInput: (String) -> Void

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.darkShadow)

            TextField("Search for a letter", text: $text)
                .onChange(of: text) {_, newValue in
                    // If the user types a space
                    if newValue == " " {
                        text = ""
                        onValidInput("Space")
                    } else {
                        // allow only one alphabetic character A–Z
                        let filtered = newValue.uppercased().suffix(1)
                        if filtered.range(of: "[A-Z]", options: .regularExpression) != nil {
                            text = String(filtered)
                            onValidInput(text)
                        } else {
                            text = ""
                        }
                    }
                }
        }
        .padding()
        .foregroundStyle(Color.neumorphictextColor)
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(6)
        .modifier(ShadowModifier())
    }
}


extension Color {
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}



