//
//  RegionSelectionView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.



import SwiftUI

struct RegionSelectionView: View {
    @EnvironmentObject var flagService: FlagService
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible())]
    
    struct regionCard: Identifiable {
        let id = UUID()
        let title: String
        let systemImage: String   // veya asset adı
    }

    /// Sabit kartlar
    private let regionCards: [regionCard] = [
        .init(title: "Europe",
              systemImage: "globe.europe.africa.fill"),
        .init(title: "Americas",
              systemImage: "globe.americas.fill"),
        .init(title: "Asia",
              systemImage: "globe.asia.australia.fill"),
        .init(title: "Africa",
              systemImage: "globe.europe.africa.fill"),
        .init(title: "Oceania",
              systemImage: "globe.central.south.asia.fill"),
        .init(title: "Other",
             systemImage: "globe")
    ]
    
    
    
    var body: some View {
        ZStack {
            // Background
            BackgroundView()
            // Foreground content
            VStack(alignment: .leading, spacing: 24) {
                Text("Choose a region")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .bold()

                LazyVGrid(columns: columns,
                          spacing: 24) {
                    ForEach(regionCards) { region in
                        NavigationLink {
                            ContentView(flagList: flagService.flags(region: region.title))
                        } label: {
                            VStack(spacing: 12) {
                                Image(systemName: region.systemImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)

                                Text(region.title.uppercased())
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
            .padding()
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .tint(.white)               // back button & title tint
        .onAppear {
            flagService.fetchFlags()
        }
    }
}
