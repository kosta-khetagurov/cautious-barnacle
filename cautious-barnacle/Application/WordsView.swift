//
//  TranslateView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

protocol WordsView: UIView {
    func update(with data: WordsViewInputData)
}

class WordsViewImp: UIView, WordsView {
    private var words: [WordCellInputData] = []
    private var tableView: UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(type: WordTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        
        tableView.pinEdges(to: self)
    }
    
    func update(with data: WordsViewInputData) {
        words = data.wordCellInputData
        tableView?.reloadData()
    }
}

struct WordsViewInputData {
    let wordCellInputData: [WordCellInputData]
    let error: Error?
    let isLoading: Bool
}

extension WordsViewImp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.identifier, for: indexPath) as? WordTableViewCell else {
            fatalError("No such TableViewCell")
        }
        cell.configure(with: words[indexPath.row].word)
        return cell
    }
}

extension WordsViewImp: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) else {
            fatalError("No such cell")
        }
        let word = words[indexPath.row]
        word.onSelect?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
