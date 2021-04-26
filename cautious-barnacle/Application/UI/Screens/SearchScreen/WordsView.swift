//
//  TranslateView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

protocol WordsView: UIView {
    func setToTableView(onDragToBottom: (()->Void)?)
    func update(with data: WordsViewInputData)
}

class WordsViewImp: UIView, WordsView {
    
    private let stackView = UIStackView()
    private var tableView = WordsTableView(frame: .zero, style: .plain)
    private var errorView = ErrorView()
    
    private var onDragToBottom: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        tableView.onDragToBottom = onDragToBottom
        backgroundColor = .systemBackground
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(errorView)
        stackView.pinEdges(to: self)
    }
    
    func setToTableView(onDragToBottom: (()->Void)?) {
        tableView.onDragToBottom = onDragToBottom
    }
    
    func update(with data: WordsViewInputData) {
        if data.error != nil {
            errorView.update(with: data.error!.localizedDescription)
            tableView.isHidden = true
            errorView.isHidden = false
        } else {
            tableView.updateDataSource(with: data.wordCellInputData)
            tableView.isHidden = false
            errorView.isHidden = true
        }
    }
}

struct WordsViewInputData {
    let wordCellInputData: [WordCellInputData]
    let error: Error?
}
