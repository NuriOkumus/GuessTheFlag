//
//  GuessTheFlagApp.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 20.07.2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct GuessTheFlagApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var flagService = FlagService()
    @AppStorage("hasSeenHowToPlay") private var hasSeenHowToPlay: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if authVM.isSignedIn {
                if hasSeenHowToPlay {
                    HomePageView()
                        .environmentObject(flagService)
                        .environmentObject(authVM)
                } else {
                    HowToPlayView()
                        .environmentObject(flagService)
                        .environmentObject(authVM)
                        .onDisappear {
                            hasSeenHowToPlay = true
                        }
                }
            } else {
                LoginView()
                    .environmentObject(authVM)
            }
        }
    }
}
