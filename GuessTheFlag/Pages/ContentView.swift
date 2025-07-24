//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 20.07.2025.
//

import SwiftUI
import FirebaseAuth
import UIKit

struct ShakeEffect: GeometryEffect {
    var trigger: Bool
    var amplitude: CGFloat = 10
    var animatableData: CGFloat {
        get { trigger ? 1 : 0 }
        set {}
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = trigger ? CGFloat.random(in: -amplitude...amplitude) : 0
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}


struct ContentView: View {
    var flagList: [FlagModel]
    
    @EnvironmentObject var authVM: AuthViewModel
    
    @State var Guess = ""
    @State var currentFlag: FlagModel? = nil
    @State var showResult: Bool? = nil
    @State var YourScore: Int = 0
    @State var TryChance: Int = 3
    @State var isGameOver = false
    @State var feedbackText: String = ""
    // Animation States
    @State var resultScale: CGFloat = 1.0
    @State var resultOpacity: Double = 1.0
    @State var scoreScale: CGFloat = 1.0
    @State var flagRotation: Double = 0.0
    @State var flagShake: Bool = false
    @State var showWrongOverlay: Bool = false
    @State var isCheckButtonDisabled = false
    @StateObject var firestoreService = FirestoreService()
    
    /// Haptic feedback helper
    private func haptic(success: Bool) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(success ? .success : .error)
    }
    
    func pickRandomFlag() {
        guard !flagList.isEmpty else { return }
        
        // Try to pick a flag different from the current one.
        // If there's only one flag in the list, we keep showing it.
        var newFlag = flagList.randomElement()!
        if flagList.count > 1 {
            while newFlag.name == currentFlag?.name {
                newFlag = flagList.randomElement()!
            }
        }
        currentFlag = newFlag
    }
    
    func checkAnswer() {
        guard !isCheckButtonDisabled else { return }
        isCheckButtonDisabled = true
        if let currentFlag = currentFlag, isAnswerTrue(correctans: currentFlag, ans: Guess) {
            haptic(success: true)
            withAnimation(.spring()) {
                resultScale = 1.5
                resultOpacity = 1.0
                flagRotation += 360
                scoreScale = 1.3
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    resultScale = 1.0
                    resultOpacity = 0.0
                    scoreScale = 1.0
                    
                }
            }
            showResult = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                YourScore += 1
                firestoreService.saveScore(score: YourScore)
                
                pickRandomFlag()
                Guess = ""
                showResult = nil
                isCheckButtonDisabled = false
            }
        } else {
            showResult = false
            haptic(success: false)
            feedbackText = isGuessClose(to: Guess, correct: currentFlag?.name ?? "") ? "Close Guess!" : "Wrong"
            withAnimation(.easeInOut(duration: 0.2)) {
                showWrongOverlay = true
                resultScale = 1.2
                resultOpacity = 1.0
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showWrongOverlay = false
                    resultScale = 1.0
                    resultOpacity = 0.0
                    isCheckButtonDisabled = false
                }
            }
            if TryChance > 1 {
                TryChance -= 1
            } else {
                TryChance = 0
                isGameOver = true
            }
            Guess = ""
        }
    }
    
    
    func RestartGame() {
        YourScore = 0
        pickRandomFlag()
        Guess = ""
        TryChance = 3
        showResult = nil
        isGameOver = false
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                
                BackgroundView()
                
                VStack {
                HStack(alignment: .center, spacing: 24) {
                    VStack {
                        Text("SCORE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(YourScore)")
                            .font(.title.bold())
                    }
                    Divider()
                        .frame(height: 40)
                    VStack {
                        Text("TRIES")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(max(TryChance,0))")
                            .font(.title.bold())
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(radius: 5)
                .padding(.horizontal)
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
                .controlSize(.extraLarge)
                    
                VStack(alignment: .center, spacing: 0){
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.systemBackground).opacity(0.15))
                            .shadow(radius: 4)
                            .aspectRatio(4/3, contentMode: .fit)
                        
                        if let flag = currentFlag {
                            AsyncImage(
                                url: URL(string: flag.imageUrl),
                                content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .rotationEffect(.degrees(flagRotation))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            )
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 4)
                            .overlay(
                                GeometryReader { geo in
                                    Rectangle()
                                        .fill(Color.red.opacity(0.4))
                                        .frame(width: geo.size.width, height: geo.size.height)
                                        .opacity(showWrongOverlay ? 1 : 0)
                                        .animation(.easeInOut(duration: 0.2), value: showWrongOverlay)
                                }
                            )
                        } else {
                            ProgressView()
                                .frame(height: 300)
                        }
                    }
                    
                    HStack {
                        TextField("Enter your guess", text: $Guess)
                            .textFieldStyle(.roundedBorder)
                        Button("Check") {
                            checkAnswer()
                        }
                        .disabled(TryChance <= 0 || isCheckButtonDisabled)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    // Test
                    if let correct = currentFlag {
                        Text("Correct Answer: \(correct.name)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.leading)
                    }
                }
                .padding()
                .onAppear {
                    pickRandomFlag()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Restart") {
                    RestartGame()
                }
            }
        }
    }
}
}
func isAnswerTrue(correctans: FlagModel, ans: String) -> Bool {
    let cleanedCorrect = correctans.name
        .lowercased()
        .components(separatedBy: .whitespacesAndNewlines)
        .joined()
    
    let cleanedAns = ans
        .lowercased()
        .components(separatedBy: .whitespacesAndNewlines)
        .joined()
    
    return cleanedCorrect == cleanedAns
}
