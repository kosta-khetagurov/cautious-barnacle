//
//  Meaning.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 24.04.2021.
//

import Foundation

struct Meaning: Decodable, Hashable {
    let id: String
    let wordId: Int
    let text, soundUrl: String
    let transcription: String
    let updatedAt: String
    let translation: Translation
    let images: [Meaning.Image]
    
    struct Image: Decodable, Hashable {
        let url: String
    }
}
