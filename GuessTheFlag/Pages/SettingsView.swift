//
//  SettingsView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Toggle("Haptic Feedback", isOn: .constant(true))
            Toggle("Dark Mode", isOn: .constant(false))
        }
        .navigationTitle("Settings")
    }
}
