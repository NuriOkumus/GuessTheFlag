//
//  SettingsView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("enableHaptic") private var enableHaptic = true
    @AppStorage("darkMode") private var darkMode = false

    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Toggle("Haptic Feedback", isOn: $enableHaptic)
                Toggle("Dark Mode", isOn: $darkMode)
            }

            Section {
                Button(role: .destructive) {
                    resetSettings()
                } label: {
                    Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                }
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(darkMode ? .dark : .light)
    }

    private func resetSettings() {
        enableHaptic = true
        darkMode = false
    }
}
