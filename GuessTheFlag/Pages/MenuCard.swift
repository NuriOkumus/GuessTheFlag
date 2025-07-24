//
//  MenuCard.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.
//


import SwiftUI

/// Ana menüde gösterilecek kart modeli
struct MenuCard: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String   // veya asset adı
    let destination: AnyView  // tıklanınca gideceği ekran
}

/// Sabit kartlar
private let menuCards: [MenuCard] = [
    .init(title: "Maps",
          systemImage: "map.fill",
          destination: AnyView(PlaceHolderView())),
    .init(title: "Flags",
          systemImage: "flag.fill",
          destination: AnyView(RegionSelectionView()) ),
    .init(title: "Emblems",
          systemImage: "shield.lefthalf.filled",
          destination: AnyView(PlaceHolderView())),
    .init(title: "Capitals",
          systemImage: "building.columns.fill",
          destination: AnyView(PlaceHolderView()))
]

struct HomePageView: View {
    // Ekran genişliğine göre 2 × 2 grid
    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: – Arka Plan
               BackgroundView()
                // MARK: – İçerik
                VStack(spacing: 24) {
                    
                        Text("COUNTRY QUIZ")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                    
                    LazyVGrid(columns: columns,
                              spacing: 24) {
                        ForEach(menuCards) { card in
                            NavigationLink {
                                card.destination
                            } label: {
                                VStack(spacing: 12) {
                                    Image(systemName: card.systemImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                    
                                    Text(card.title.uppercased())
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity,
                                       minHeight: 120)
                                .background(Color.white.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 16,
                                                            style: .continuous))
                                .shadow(color: .black.opacity(0.25),
                                        radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: LeaderboardView()) {
                        Image(systemName: "list.number")
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
        }
    }
}
