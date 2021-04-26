//
//  WordDetailView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

protocol WordDetailView: UIView {
    func update(with: MeaningInputData)
}

class WordDetailViewImp: UIView, WordDetailView {
    var stackView: UIStackView!
    var tableView: MeaningTableView!
    var errorView: ErrorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView = MeaningTableView(frame: .zero, style: .plain)
        errorView = ErrorView()
        
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(errorView)
        addSubview(stackView)
        stackView.pinEdges(to: self)
    }
    
    func update(with data: MeaningInputData) {
        if let error = data.error {
            errorView.update(with: error.localizedDescription)
            errorView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.update(with: data.meaningCellInputData)
            errorView.isHidden = true
            tableView.isHidden = false
        }
    }
}
