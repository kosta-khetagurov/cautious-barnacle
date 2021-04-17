//
//  WordsViewController.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

class WordsViewController <View: WordsView>: BaseViewController<View> {
    
    var wordsProvider: WordsProvider
    var onSelectWord: ((Word)->())?
    
    init(wordsProvider: WordsProvider) {
        
        self.wordsProvider = wordsProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.loadView()

        configureSearchController()
        
        let inputData = makeTranslateViewInputData(from: WordsProvider.State(words: [Word(name: "hello")], nextPage: 1, isLoadProgress: false, error: nil))
        rootView.update(with: inputData)
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        let searchUpdater = SearchUpdater()
        searchController.searchResultsUpdater = searchUpdater
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func makeTranslateViewInputData(from state: WordsProvider.State) -> WordsViewInputData {
        return WordsViewInputData(wordCellInputData: [makeWordViewCellInputData(from: Word(name: "Hello!"))], error: nil, isLoading: false)
    }
    
    private func makeWordViewCellInputData(from word: Word) -> WordCellInputData {
        return WordCellInputData(word: word, onSelect: { [weak self] in self?.onSelectWord!(word)})
    }
    
}

class SearchUpdater: NSObject, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.debugDescription)
    }
}

struct WordCellInputData {
    let word: Word
    let onSelect: (()->())?
}

class WordsProvider {
    struct State {
        let words: [Word]
        let nextPage: Int
        let isLoadProgress: Bool
        let error: Error?
    }
    
    init(service: WordService) {
        
    }
}

class WordService {
    
    
}
