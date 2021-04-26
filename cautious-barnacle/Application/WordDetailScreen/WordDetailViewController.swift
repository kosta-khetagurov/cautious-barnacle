//
//  WordDetailViewController.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

//- Экран, отображающий подробную информацию о слове (текст, перевод и картинка, остальные поля по желанию), открывается по нажатию на ячейку в таблице с результатами поиска
class WordDetailViewController <View: WordDetailView>: BaseViewController<View> {
    private var meaningProvider: MeaningProviderImp
    
    init(meaningProvider: MeaningProviderImp) {
        self.meaningProvider = meaningProvider

        super.init(nibName: nil, bundle: nil)
        
        self.meaningProvider.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.loadView()
        
        meaningProvider.loadMeanings()
    }
}

extension WordDetailViewController: MeaningProviderDelegate {
    func provide(meanings: [Meaning]) {
        let meaningCellInputData = meanings.map({MeaningCellInputData(meaning: $0)})
        let inputData = MeaningInputData(meaningCellInputData: meaningCellInputData, error: nil)
        DispatchQueue.main.async { [weak self] in
            self?.rootView.update(with: inputData)
        }
    }
    
    func provide(error: Error) {
        let inputData = MeaningInputData(meaningCellInputData: [], error: error)
        DispatchQueue.main.async { [weak self] in
            self?.rootView.update(with: inputData)
        }
    }
}

struct MeaningInputData {
    let meaningCellInputData: [MeaningCellInputData]
    let error: Error?
}

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
