//
//  FirestoreService.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 22.07.2025.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    
    func saveScore(score: Int) {
        guard let user = Auth.auth().currentUser else { return }

        let docRef = db.collection("scores").document(user.uid)
        docRef.getDocument { snapshot, error in
            if let data = snapshot?.data(), let currentHighScore = data["highScore"] as? Int {
                if score > currentHighScore {
                    docRef.setData(["username": user.email ?? "unknown", "highScore": score])
                }
            } else {
                docRef.setData(["username": user.email ?? "unknown", "highScore": score])
            }
        }
    }
    
    func fetchTopScores(limit: Int = 3, completion: @escaping ([LeaderboardEntry]) -> Void) {
        db.collection("scores")
            .order(by: "highScore", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }

                let entries = docs.compactMap { doc -> LeaderboardEntry? in
                    let data = doc.data()
                    guard let username = data["username"] as? String,
                          let score = data["highScore"] as? Int else {
                        return nil
                    }
                    return LeaderboardEntry(username: username, score: score)
                }
                completion(entries)
            }
    }

    // MARK: - Async / Await Wrapper
    @MainActor
    func fetchTopScoresAsync(limit: Int = 3) async -> [LeaderboardEntry] {
        await withCheckedContinuation { continuation in
            self.fetchTopScores(limit: limit) { entries in
                continuation.resume(returning: entries)
            }
        }
    }
}

struct LeaderboardEntry: Identifiable {
    var id = UUID()
    var username: String
    var score: Int
}
