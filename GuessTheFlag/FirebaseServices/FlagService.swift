//
//  FlagService.swift
//  GuessTheFlag
//
//  Created by Nuri Okumuş on 23.07.2025.
//


//
//  FlagService.swift
//  GuessTheFlag
//
//  Created by ChatGPT on 23.07.2025.
//
//  Sorumluluğu: Firestore’daki "flags" koleksiyonunu tek seferde çekip
//  bellek içinde tutmak ve bölge / zorluk bazlı filtre yardımcıları sunmak.
//

import Foundation
import FirebaseFirestore
import Combine

class FlagService: ObservableObject {
    // Tüm bayrakları tek yerde tutar
    @Published var flags: [FlagModel] = []
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    /// Firestore’dan verileri dinler. Çağrıyı bir kereden fazla yaparsan ikinci kez çalışmaz.
    func fetchFlags() {
        guard listener == nil else { return }    // zaten dinliyorsak çık
        
        listener = db.collection("flags")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                if let docs = snapshot?.documents {
                    self.flags = docs.compactMap { try? $0.data(as: FlagModel.self) }
                }
            }
    }
    
    // MARK: - Yardımcı Filtre Fonksiyonları
    
    /// Mevcut veriden bölge listesi (tekrarsız + alfabetik)
    var regions: [String] {
        Array(Set(flags.map { $0.region })).sorted()
    }
    
    /// Seçilen bölgede mevcut zorluk seviyeleri
    func difficulties(in region: String) -> [String] {
        Array(Set(flags.filter { $0.region == region }.map { $0.difficulty })).sorted()
    }
    
    /// Bölge + zorluk filtresine uyan bayraklar
    func flags(region: String,) -> [FlagModel] {
        flags.filter { $0.region == region}
    }
    
    deinit {
        listener?.remove()
    }
}
