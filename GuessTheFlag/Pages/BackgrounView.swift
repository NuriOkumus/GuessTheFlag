//
//  BackgrounView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 24.07.2025.
//

import SwiftUI


// MARK: - GradientStyle helper
struct GradientStyle {
    let colors: [Color]
    let start: UnitPoint
    let end: UnitPoint

    /// Preset palette options
    static let presets: [GradientStyle] = [
        .init(colors: [.mint, .cyan],
              start: .topLeading, end: .bottomTrailing),
        .init(colors: [.pink, .orange],
              start: .top,       end: .bottom),
        .init(colors: [.purple, .indigo],
              start: .leading,   end: .trailing),
        .init(colors: [.yellow, .red],
              start: .bottomLeading, end: .topTrailing),
        .init(colors: [.backgroundNew, .backgroundNew2],
              start: .bottomLeading, end: .topTrailing)
    ]

    /// Random pick
    static func random() -> GradientStyle {
        presets.randomElement()!
    }
}

struct BackgroundView: View {
    // Pick a random style once per View lifecycle
    @State private var style: GradientStyle = .random()
    // Optional: animate gradient direction reversal
    @State private var shift = false

    var body: some View {
        LinearGradient(colors: style.colors,
                       startPoint: shift ? style.end : style.start,
                       endPoint:   shift ? style.start : style.end)
            .ignoresSafeArea()
            .onAppear {
                // Slow, infinite back‑and‑forth animation
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    shift.toggle()
                }
            }
    }
}

