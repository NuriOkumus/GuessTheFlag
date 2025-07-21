//
//  FlagModel.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 20.07.2025.
//

import Foundation 


struct FlagModel: Identifiable, Codable {
    let id = UUID()
    let code: String   // "tr"
    let name: String   // "Turkey"

    var imageUrl: URL? {
        URL(string: "https://flagcdn.com/w320/\(code.lowercased()).png")
    }
}
