//
//  FlagModel.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 20.07.2025.
//


import Foundation
import FirebaseFirestore   // Codable için

struct FlagModel: Identifiable, Codable {
    let id: String?       // Firestore belgesi ID’si

    let code: String
    let name: String
    let imageUrl: String
    let chapter: Int
    let region: String
    let difficulty: String
}
