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
    private let tableView: UITableView
    
    override init(frame: CGRect) {
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(type: WordTableViewCell.self)
        
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        tableView.pinEdges(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with data: WordsViewInputData) {
        self.words = data.wordCellInputData
        self.tableView.reloadData()
    }
}

struct WordsViewInputData {
    let wordCellInputData: [WordCellInputData]
    let error: Error?
    let isLoading: Bool
}

extension WordsViewImp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(words.count)
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
