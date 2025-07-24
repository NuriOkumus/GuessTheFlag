//
//  BackgrounView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 24.07.2025.
//

import SwiftUI


struct BackgroundView: View {
    var body: some View {
        LinearGradient(colors: [Color("BackgroundTop"),
                                               Color("BackgroundBottom")],
                                      startPoint: .top,
                                      endPoint: .bottom)
                           .ignoresSafeArea()
                           .edgesIgnoringSafeArea(.all)
    }
}

