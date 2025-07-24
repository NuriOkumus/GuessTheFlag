//
//  AuthViewModel.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 22.07.2025.
//


import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
        @Published var isSignedIn = false
        @Published var errorMessage = ""
        
        private var listener: AuthStateDidChangeListenerHandle?
        
    
    var currentUserEmail: String {
        Auth.auth().currentUser?.email ?? "Unknown"
    }
    
        init() {
            // Uygulama ilk açıldığında mevcut kullanıcıyı kontrol et
            isSignedIn = Auth.auth().currentUser != nil
            
            // Oturumda her değişiklik olduğunda (login / logout) tetiklenir
            listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                self?.isSignedIn = (user != nil)
            }
        }
        
        deinit {
            if let listener { Auth.auth().removeStateDidChangeListener(listener) }
        }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isSignedIn = true
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isSignedIn = true
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        isSignedIn = false
    }
}
