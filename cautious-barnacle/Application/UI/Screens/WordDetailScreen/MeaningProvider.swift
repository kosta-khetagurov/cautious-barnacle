//
//  MeaningProvider.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 26.04.2021.
//

import Foundation

protocol MeaningProviderDelegate: class {
    func provide(meanings: [Meaning])
    func provide(error: Error)
}

protocol MeaningProvider {}

class MeaningProviderImp: MeaningProvider {
    
    let wordsService: WordsServiceImp
    let meaningsIds: String
    weak var delegate: MeaningProviderDelegate?
    
    init(wordsService: WordsServiceImp, meaningsIds: String) {
        self.wordsService = wordsService
        self.meaningsIds = meaningsIds
    }
    
    func loadMeanings() {
        wordsService.loadMeanings(ids: meaningsIds) { [self] (result) in
            switch result {
            case .success(let meanings):
                delegate?.provide(meanings: meanings)
            case .failure(let error):
                delegate?.provide(error: error)
            }
        }
    }
}
