//
//  AppCoordinator.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 16.04.2021.
//

final class AppCoordinator: BaseCoordinator {
        
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        showTranslateScreen()
    }
    
    private func showTranslateScreen() {
        let vc = screenFactory.makeTraslateScreen()
        vc.onSelectWord = showDetail
        router.push(vc)
    }
    
    private func showDetail(of word: Word) {
        let vc = screenFactory.makeWordDetailScreen(of: word)
        router.push(vc)
    }
    
}
