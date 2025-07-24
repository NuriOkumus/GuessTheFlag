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
        ZStack {
            // Background gradient
            
            BackgroundView()

            VStack(spacing: 20) {
                Text("🏆 Leaderboard")
                    .font(.largeTitle.bold())

                if topUsers.isEmpty {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    // Ranked list
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(topUsers.enumerated()), id: \.element.id) { index, entry in
                                HStack {
                                    // Medal or rank
                                    Text(index < 3 ? ["🥇","🥈","🥉"][index] : "#\(index + 1)")
                                        .font(.title3)
                                        .frame(width: 40, alignment: .leading)

                                    // Display name (truncate email to username)
                                    Text(entry.username.components(separatedBy: "@").first ?? entry.username)
                                        .fontWeight(index == 0 ? .bold : .regular)
                                        .lineLimit(1)

                                    Spacer()

                                    // Score
                                    Text("\(entry.score) pts")
                                        .bold()
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                                .background(
                                    index == 0 ? Color.yellow.opacity(0.15) :
                                    index == 1 ? Color.gray.opacity(0.12) :
                                    index == 2 ? Color.orange.opacity(0.10) : Color.clear
                                )

                                // Divider between rows
                                if index != topUsers.count - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 5)
                    .frame(maxHeight: 420)
                    .scrollIndicators(.hidden)
                }
            }
            .padding()
        }
        .navigationTitle("Leaderboard")
        .task {
            // Fetch scores asynchronously on first appearance
            topUsers = await firestoreService.fetchTopScoresAsync()
        }
    }
}
