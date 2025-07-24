//
//  ProfileView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.
//

import SwiftUI

struct ProfileView : View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body : some View {
        
        VStack {
            Text("Profile View")
            
            Group {
                Text("Current User : \(authVM.currentUserEmail)")
                Button(action: authVM.logout) {
                    Label("Logout", systemImage: "square.and.arrow.up")
                }
            }
        }
        
        
        
        
        
    }
}
