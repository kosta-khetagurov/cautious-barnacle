//
//  WordsService.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 18.04.2021.
//

import Foundation

protocol WordsService {
    func loadWords(by text: String, page: Int, perPage: Int, completion: @escaping ([Word], WordsError?)->())
}

class WordsServiceImp: WordsService {
    func loadWords(by text: String, page: Int, perPage: Int, completion: @escaping ([Word], WordsError?)->()) {
        let resource = makeSearchResource(for: text, at: page, size: perPage)
        Environment.env.session.load(resource) { (words) in
            guard let words = words else {return}
            completion(words, nil)
        }
    }
}
