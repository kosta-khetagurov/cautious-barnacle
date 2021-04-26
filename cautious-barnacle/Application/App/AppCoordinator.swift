//
//  AppCoordinator.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 16.04.2021.
//

final class AppCoordinator: BaseCoordinator {
        
    private let screenFactory: ScreenFactory
    private let router: Router
    private let wordsProvider: WordsProviderImp
    private let wordsService: WordsServiceImp
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
        self.wordsService = WordsServiceImp()
        self.wordsProvider = WordsProviderImp(wordsService: self.wordsService)
    }
    
    override func start() {
        showTranslateScreen()
    }
    
    private func showTranslateScreen() {
        let vc = screenFactory.makeTraslateScreen(wordsProvider: wordsProvider)
        vc.onSelectWord = showDetail
        router.push(vc)
    }
    
    private func showDetail(of word: Word) {
        let vc = screenFactory.makeWordDetailScreen(of: word, wordsService: wordsService)
        router.push(vc)
    }
    
}
