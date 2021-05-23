//
//  WordsProvider.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 18.04.2021.
//

import Foundation
import UIKit

protocol WordsProviderDelegate: class {
    func provide(state: WordsProviderState)
}

class WordsProviderImp {

    private var wordsService: WordsService
    
    private(set) var state: WordsProviderState {
        didSet {
            delegate?.provide(state: state)
        }
    }
    
    private var isLoading: Bool = false
    private let queue = DispatchQueue(label: "com.cautios-barnacle.safe")
    private var workItem: DispatchWorkItem?
    
    private static let perPage = 20
    private static let firstPage = 1
    
    weak var delegate: WordsProviderDelegate?
    
    init(wordsService: WordsService = WordsServiceImp(),
         state: WordsProviderState = WordsProviderState.initial) {
        self.wordsService = wordsService
        self.state = state
    }

    func nextPage() {
        if isLoading {
            return
        }
        
        isLoading = true
        
        workItem = DispatchWorkItem(qos: .userInitiated, block: {
            [weak self] in
            guard let self = self,
                  !self.state.allWordsLoaded else { return }
            if self.state.searchedText.isEmpty  {
                self.state = .initial
                return
            }
            self.wordsService.loadWords(
                by: self.state.searchedText,
                page: self.state.nextPage + 1,
                perPage: WordsProviderImp.perPage) {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let words):
                    self.state = self.state
                        .appendWords(words)
                        .incremetPage()
                        .allWordsLoaded(words.isEmpty)
                case .failure(let error):
                    self.state = WordsProviderState
                        .initial
                        .with(error)
                }
                self.isLoading = false
            }
        })
        if let workItem = workItem {
            queue.async(execute: workItem)
        }
    }
    
    func tryLoadWords(matching text: String = "") {
        if state.searchedText == text, isLoading {
            return
        }
        workItem?.cancel()
        isLoading = true
        workItem = DispatchWorkItem(qos: .userInitiated, block: {
            [weak self] in
            guard let self = self else { return }
            if text.isEmpty {
                self.state = .initial
                return
            }
            self.wordsService.loadWords(
                by: text,
                page: WordsProviderImp.firstPage,
                perPage: WordsProviderImp.perPage) {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let words):
                    self.state = WordsProviderState.initial.appendWords(words).set(text)
                case .failure(let error):
                    self.state = WordsProviderState.initial.with(error)
                }
                self.isLoading = false
            }
        })
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + .milliseconds(250), execute: workItem)
        }
    }
    
}

struct WordsProviderState {
    let searchedText: String
    let words: [Word]
    let nextPage: Int
    let error: Error?
    let allWordsLoaded: Bool
    
    static let initial = WordsProviderState(
        searchedText: "",
        words: [],
        nextPage: 1,
        error: nil,
        allWordsLoaded: false
    )
    
    func appendWords(_ newWords: [Word]) -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words + newWords,
            nextPage: nextPage,
            error: error,
            allWordsLoaded: allWordsLoaded
        )
    }
    
    func incremetPage() -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words,
            nextPage: nextPage + 1,
            error: error,
            allWordsLoaded: allWordsLoaded
        )
    }
    
    func with(_ error: Error?) -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words,
            nextPage: nextPage,
            error: error,
            allWordsLoaded: allWordsLoaded
        )
    }
    
    func set(_ searchedText: String) -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words,
            nextPage: nextPage,
            error: error,
            allWordsLoaded: allWordsLoaded
        )
    }
    
    func allWordsLoaded(_ allWordsLoaded: Bool) -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words,
            nextPage: nextPage,
            error: error,
            allWordsLoaded: allWordsLoaded
        )
    }
}
