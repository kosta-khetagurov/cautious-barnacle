//
//  Word.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 16.04.2021.
//

import Foundation

struct Word: Hashable, Decodable {
    let id: Int
    let text: String
    let meanings: [ShortMeaning]
}

struct ShortMeaning: Hashable, Decodable {
    let id: Int
    let partOfSpeechCode: String
    let translation: Translation
    let previewUrl: String
    let imageUrl: String
    let transcription: String
    let soundUrl: String
}

struct Translation: Hashable, Decodable {
    let text: String
    let note: String?
}
