//
//  PlaceHolderView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 24.07.2025.
//

import SwiftUI

struct PlaceHolderView: View {
    var body: some View {
        ZStack {
            
            BackgroundView()
            
            Text("Under Construction")
                .font(.title3)
                .foregroundColor(.white)
                .bold(true)
            
        }
    }
}

#Preview {
    PlaceHolderView()
}
