//
//  WordsViewController.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

class WordsViewController <View: WordsView>: BaseViewController<View>, UISearchResultsUpdating {
    
    var wordsProvider: WordsProviderImp
    var onSelectWord: ((Word)->())?
    
    init(wordsProvider: WordsProviderImp) {
        self.wordsProvider = wordsProvider

        super.init(nibName: nil, bundle: nil)
        
        self.wordsProvider.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.loadView()
        
        configureSearchController()
        rootView.setToTableView(onDragToBottom: {
            [weak self] in
            self?.wordsProvider.nextPage()
        })
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func makeWordsViewInputData(from state: WordsProviderState) -> WordsViewInputData {
        return WordsViewInputData(
            wordCellInputData: state.words.map(makeWordViewCellInputData),
            error: state.error)
    }
    
    private func makeWordViewCellInputData(from word: Word) -> WordCellInputData {
        return WordCellInputData(word: word, onSelect: { [weak self] in self?.onSelectWord!(word)})
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            wordsProvider.loadWords()
            return
        }
        wordsProvider.loadWords(matching: text)
    }
}

extension WordsViewController: WordsProviderDelegate {
    func provide(state: WordsProviderState) {
        let inputData = makeWordsViewInputData(from: state)
        
        DispatchQueue.main.async {
            self.rootView.update(with: inputData)
        }
    }
}

struct WordCellInputData: Hashable {
    let word: Word
    let onSelect: (()->())?

    func hash(into hasher: inout Hasher) {
        hasher.combine(word.id)
    }
    
    static func == (lhs: WordCellInputData, rhs: WordCellInputData) -> Bool {
        lhs.word.id == rhs.word.id
    }
}
