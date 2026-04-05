//
//  HomeView.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/27/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var currentPage: Int = 0
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            if currentPage == 0 {
                HomePanel(currentPage: $currentPage)
            }
            else if currentPage == 1 {
                TranscriptHistoryView(currentPage: $currentPage, selectedTab: $selectedTab)
            }
            else if currentPage == 2 {
                HelpView(currentPage: $currentPage)
            }
            else { //curentPage == 3
                ExploreView(currentPage: $currentPage, selectedTab: $selectedTab)
            }
        }
        
    }
}

