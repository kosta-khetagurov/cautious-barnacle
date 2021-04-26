//
//  WordsService.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 18.04.2021.
//

import Foundation

protocol WordsService {
    var environment: Environment { get }
    func loadWords(by text: String, page: Int, perPage: Int, completion: @escaping (Result<[Word], Error>)->())
    func loadMeanings(ids: String, completion: @escaping (Result<[Meaning], Error>)->())
}

class WordsServiceImp: WordsService {
    let environment: Environment
    
    init(environment: Environment = Environment()) {
        self.environment = environment
    }
    
    func loadWords(by text: String, page: Int, perPage: Int, completion: @escaping (Result<[Word], Error>)->()) {
        let resource = makeSearchResource(for: text, at: page, size: perPage)
        environment.session.load(resource) { (result) in
            completion(result)
        }
    }
    
    func loadMeanings(ids: String, completion: @escaping (Result<[Meaning], Error>)->()) {
        let resource = makeMeaningResource(for: ids)
        environment.session.load(resource) { (meanings) in
            completion(meanings)
        }
    }
}
