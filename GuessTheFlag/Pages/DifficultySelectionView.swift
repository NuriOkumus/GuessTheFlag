//
//  DifficultySelectionView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.
//

import SwiftUI

// KULLANDIMDA DEĞİL !

struct DifficultySelectionView: View {
    @EnvironmentObject var flagService: FlagService
    
    let selectedRegion: String
    
    var body: some View {
        List(flagService.difficulties(in: selectedRegion), id: \.self) { level in
            NavigationLink(level) {
                let list = flagService.flags(region: selectedRegion,
                                             )
                ContentView(flagList: list) // mevcut oyun ekranın
            }
        }
        .navigationTitle(selectedRegion)
    }
}
