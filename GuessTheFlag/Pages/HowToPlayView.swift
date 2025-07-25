//
//  HowToPlayView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 25.07.2025.
//

import SwiftUI

struct HowToPlayView: View {
    @State private var currentPage = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    // Flag that decides whether onboarding is shown
    @AppStorage("hasSeenHowToPlay") private var hasSeenHowToPlay: Bool = false
    /// Show or hide the close (X) button
    var showCloseButton: Bool = true
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            Color.cyan.opacity(0.4)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    Text("How to play")
                        .font(.title)
                        .fontWeight(.bold)
                    if showCloseButton {
                        HStack {
                            Spacer()
                            Button(action: {
                                // Mark onboarding as seen and switch to HomePage
                                hasSeenHowToPlay = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                        }
                    }
                }
                TabView(selection: $currentPage) {
                    view1.tag(0)
                    view2.tag(1)
                    view3.tag(2)
                    view1.tag(3) // duplicate for seamless looping
                }
                
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .onReceive(timer) { _ in
                    withAnimation {
                        currentPage += 1
                    }
                    if currentPage == 3 {
                        // After the forward animation to the duplicate page completes,
                        // snap back to the real first page without animation.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            currentPage = 0
                        }
                    }
                }
            }
        }
    }
}

var view1: some View {
    VStack {
        Text("Choose a game mode")
                .font(.headline)
        Image("MainMenu")
            .resizable()
            .scaledToFit()
            .padding(.bottom, 20)
    }
}

var view2: some View {
    VStack {
        Text("Choose a region")
                .font(.headline)
        Image("RegionSelectorPage")
            .resizable()
            .scaledToFit()
            .padding(.bottom, 20)
    }
}

var view3: some View {
    VStack {
        Text("Enter your guess")
                .font(.headline)
        Image("GamePage")
            .resizable()
            .scaledToFit()
            .padding(.bottom, 20)
        }
}

#Preview {
    HowToPlayView(showCloseButton: true)
}
