//
//  ProfileView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.
//

import SwiftUI

struct ProfileView : View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background
            BackgroundView()
            
            VStack(spacing: 24) {

                // Avatar
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(radius: 10)

                // Email card
                VStack(spacing: 8) {
                    Text("SIGNED IN AS")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(authVM.currentUserEmail)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(radius: 5)

                // Logout button
                Button(role: .destructive, action: authVM.logout) {
                    Label("Logout", systemImage: "arrow.right.square")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
