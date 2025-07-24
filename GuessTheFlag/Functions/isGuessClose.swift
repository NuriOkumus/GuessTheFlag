//
//  isGuessClose.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 21.07.2025.
//

// Levenshtein Algorithm For Comparing Strings

func isGuessClose(to guess: String, correct: String) -> Bool {
    let guess = guess.lowercased()
    let correct = correct.lowercased()
    
    let m = guess.count
    let n = correct.count
    if m == 0 || n == 0 { return false }

    let guessArray = Array(guess)
    let correctArray = Array(correct)
    
    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
    
    for i in 0...m { dp[i][0] = i }
    for j in 0...n { dp[0][j] = j }
    
    for i in 1...m {
        for j in 1...n {
            if guessArray[i - 1] == correctArray[j - 1] {
                dp[i][j] = dp[i - 1][j - 1]
            } else {
                dp[i][j] = min(dp[i - 1][j - 1], min(dp[i][j - 1], dp[i - 1][j])) + 1
            }
        }
    }
    
    let distance = dp[m][n]
    let maxLen = max(m, n)
    let similarity = (1.0 - Double(distance) / Double(maxLen)) * 100.0
    return similarity >= 60.0
}
