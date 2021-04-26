//
//  WordDetailViewController.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

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
