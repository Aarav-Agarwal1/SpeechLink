//
//  AudioTranscriptionHelpView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 8/2/25.
//

import SwiftUI

struct AudioTranscriptionHelpView: View {
    @Binding var currentCategory: Int
    var body: some View {
        VStack {
            Button(action: {
                currentCategory = 0
            }, label: {
                BackButton()
            })
            TitleView(title: "Recording Audio")
            ScrollView {
                
                SectionView(title: "Recording audio", content: "To start recording, tap the \"Record\" button. You can pstop at any time. When you're done, your audio will be saved and transcribed.")
                
                SectionView(title: "Microphone Not Working", content: "You need to grant the app access to use your speakers and microphone in order to transcribe audio into text and in order to hear old transcripts. If the transcription is not working, try closing the app and reopening it.")
                
                SectionView(title: "Viewing Transcripts", content: "After recording, the transcript appears in the home page under \"Transcript History View.\"")
                
                SectionView(title: "Playback Controls", content: "When recording transcripts, you can start recording, pause the recording, resume the recording, and stop the recording.\nWhen looking at old transcripts, you can also play a recording of that transcript back.")
                
            }
        }
        
        
    }
}
