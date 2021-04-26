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
    
    private(set) var state = WordsProviderState.initial {
        didSet {
            delegate?.provide(state: state)
        }
    }
    
    private let queue = DispatchQueue(label: "com.cautios-barnacle.safe")
    private var workItem: DispatchWorkItem?
    private let perPage = 20
    
    weak var delegate: WordsProviderDelegate?
    
    init(wordsService: WordsService = WordsServiceImp()) {
        self.wordsService = wordsService
    }
    
    func nextPage() {
        workItem?.cancel()
        workItem = DispatchWorkItem(qos: .userInitiated, flags: [], block: {
            [weak self] in
            guard let self = self else { return }
            if self.state.searchedText.isEmpty {
                self.state = .initial
                return
            }
            self.wordsService.loadWords(
                by: self.state.searchedText,
                page: self.state.nextPage + 1,
                perPage: self.perPage) {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let words):
                    var newState = self.state.appendWords(words)
                    if !words.isEmpty {
                        newState = newState.incremetPage()
                    }
                    self.state = newState
                case .failure(_):
                    self.state = WordsProviderState.initial.with(WordsError(kind: .noResults))
                }
            }
        })

        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + .milliseconds(250), execute: workItem)
        }
    }
    
    func loadWords(matching text: String = "") {
        workItem?.cancel()
        workItem = DispatchWorkItem(qos: .userInitiated, flags: [], block: {
            [weak self] in
            guard let self = self else { return }
            if text.isEmpty {
                self.state = .initial
                return
            }
            self.wordsService.loadWords(
                by: text,
                page: self.state.nextPage,
                perPage: self.perPage) {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let words):
                    self.state = WordsProviderState.initial.appendWords(words).set(text)
                case .failure(_):
                    self.state = WordsProviderState.initial.with(WordsError(kind: .noResults))
                }
            }
        })
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + .milliseconds(250), execute: workItem)
        }
    }
}

class WordsError: Error, LocalizedError {
    enum ErrorKind {
        case noResults
    }
    var kind: ErrorKind
    
    init(kind: ErrorKind) {
        self.kind = kind
    }
    var errorDescription: String? {
        switch self.kind {
        case .noResults:
            return "No Results"
        }
    }
}

struct WordsProviderState {
    let searchedText: String
    let words: [Word]
    let nextPage: Int
    let error: WordsError?
    
    static let initial = WordsProviderState(
        searchedText: "",
        words: [],
        nextPage: 1,
        error: nil
    )
    
    func appendWords(_ newWords: [Word]) -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words + newWords,
            nextPage: nextPage,
            error: error
        )
    }
    
    func incremetPage() -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words,
            nextPage: nextPage + 1,
            error: error
        )
    }
    
    func with(_ error: WordsError?) -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words,
            nextPage: nextPage,
            error: error
        )
    }
    func set(_ searchedText: String) -> Self {
        return WordsProviderState(
            searchedText: searchedText,
            words: words,
            nextPage: nextPage,
            error: error
        )
    }
}
