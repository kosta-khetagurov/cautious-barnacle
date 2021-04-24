//
//  ScreenFactory.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 16.04.2021.
//
import UIKit

protocol ScreenFactory {
    func makeTraslateScreen() -> WordsViewController<WordsViewImp>
    func makeWordDetailScreen(of: Word) -> WordDetailViewController<WordDetailViewImp>
}

class ScreenFactoryImp: ScreenFactory {
    func makeTraslateScreen() -> WordsViewController<WordsViewImp> {
        let screen = WordsViewController<WordsViewImp>(wordsProvider: WordsProviderImp())
        screen.navigationItem.title = "Все слова"
        return screen
    }
    
    func makeWordDetailScreen(of word: Word) -> WordDetailViewController<WordDetailViewImp> {
        let screen = WordDetailViewController<WordDetailViewImp>()
        screen.navigationItem.title = word.text
        return screen
    }

}
