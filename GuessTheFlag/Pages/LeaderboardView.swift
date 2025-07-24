//
//  LeaderboardView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 22.07.2025.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject var firestoreService = FirestoreService()
    @State var topUsers: [LeaderboardEntry] = []
    
    var body: some View {
        VStack {
            Text("🏆 Leaderboard")
                .font(.title)
                .bold()
                .padding(.bottom)
            
            List(topUsers) { entry in
                HStack {
                    Text(entry.username)
                    Spacer()
                    Text("\(entry.score) pts")
                        .bold()
                }
            }
        }
        .onAppear {
            firestoreService.fetchTopScores { scores in
                topUsers = scores
            }
        }
    }
}
