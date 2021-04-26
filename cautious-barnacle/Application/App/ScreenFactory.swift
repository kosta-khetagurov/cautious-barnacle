//
//  ScreenFactory.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 16.04.2021.
//
import UIKit

protocol ScreenFactory {
    func makeTraslateScreen(wordsProvider: WordsProviderImp)-> WordsViewController<WordsViewImp>
    func makeWordDetailScreen(of word: Word, wordsService: WordsServiceImp) -> WordDetailViewController<WordDetailViewImp>
}

class ScreenFactoryImp: ScreenFactory {
    func makeTraslateScreen(wordsProvider: WordsProviderImp)-> WordsViewController<WordsViewImp> {
        let screen = WordsViewController<WordsViewImp>(wordsProvider: wordsProvider)
        screen.navigationItem.title = "Все слова"
        return screen
    }
    
    func makeWordDetailScreen(of word: Word, wordsService: WordsServiceImp) -> WordDetailViewController<WordDetailViewImp> {
        let meaningsIds = word.meanings.compactMap({String($0.id)}).joined(separator: ",")
        let meaningProvider = MeaningProviderImp(wordsService: wordsService, meaningsIds: meaningsIds)
        let screen = WordDetailViewController<WordDetailViewImp>(meaningProvider: meaningProvider)
        screen.navigationItem.title = word.text
        return screen
    }

}
