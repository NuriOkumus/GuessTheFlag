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
        currentFlag = flagList.randomElement()
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
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 140)
                    VStack {
                        VStack {
                            Text("Your Score : \(YourScore)")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                                .scaleEffect(scoreScale)
                                .animation(.spring(), value: scoreScale)
                            
                            HStack {
                                Button("Restart Game") {
                                    RestartGame()
                                }
                                .disabled(TryChance > 0)
                                Spacer()
                                Text("Remaning Try: \(max(TryChance,0))")
                                    .font(.title2)
                            }
                            
                            ZStack {
                                if let result = showResult {
                                    if result {
                                        Text("Correct")
                                            .foregroundColor(.green)
                                            .font(.title2)
                                            .multilineTextAlignment(.center)
                                            .scaleEffect(resultScale)
                                            .opacity(resultOpacity)
                                    } else {
                                        Text(isGameOver ? "Game is Over" : feedbackText)
                                            .foregroundColor(.red)
                                            .font(.title2)
                                            .multilineTextAlignment(.center)
                                            .scaleEffect(resultScale)
                                            .opacity(resultOpacity)
                                    }
                                } else if TryChance == 3 {
                                    Text("Take a Guess")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal)
                    }
                }
                
                VStack(alignment: .center, spacing: 0){
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width : 400, height: 280)
                        
                        if let flag = currentFlag {
                            AsyncImage(
                                url: URL(string: flag.imageUrl),
                                content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .rotationEffect(.degrees(flagRotation))
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            )
                            .frame(height: 300)
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
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
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
        }}
}
}
func isAnswerTrue( correctans : FlagModel , ans : String) -> Bool {
    
    if correctans.name.lowercased() == ans.lowercased() {
        return true
    }else {
        return false
    }

}
