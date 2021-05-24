//
//  WordsTableView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 22.04.2021.
//

import UIKit

class WordsTableView: UITableView {
    typealias SectionIdentifier = Int
    typealias ItemIdentifier = WordCellInputData
    
    var diffableDataSource: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier>?
    var onDragToBottom: (()->Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    
    private func setup() {
        configureSubscriptions()
        
        delegate = self
        register(type: WordTableViewCell.self)
        diffableDataSource = UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier>(tableView: self, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withType: WordTableViewCell.self, for: indexPath)
            cell.configure(with: item.word)
            return cell
        })
    
    }
    
    func updateDataSource(with cells: [WordCellInputData]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        snapshot.appendSections([1])
        snapshot.appendItems(cells, toSection: 1)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }

    
    private func configureSubscriptions() {
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { [weak self] (notification) in
            
            let info = notification.userInfo
            guard let kbsize = (info?["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.size else { return }
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbsize.height, right: 0)
            self?.contentInset = contentInset
            self?.scrollIndicatorInsets = contentInset
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { [weak self] (notification) in
            let contentInset = UIEdgeInsets.zero
            self?.contentInset = contentInset
            self?.scrollIndicatorInsets = contentInset
        }
    }
}

extension WordsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        diffableDataSource?.itemIdentifier(for: indexPath)?.onSelect?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10.0 {
            onDragToBottom?()
        }
    }
}
