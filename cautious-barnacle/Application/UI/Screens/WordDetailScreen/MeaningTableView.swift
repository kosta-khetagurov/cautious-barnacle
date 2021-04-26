//
//  MeaningTableView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 26.04.2021.
//

import UIKit

class MeaningTableView: UITableView {
    typealias SectionIdentifier = String
    typealias ItemIdentifier = MeaningCellInputData
    
    private var diffableDataSource: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier>?
    private var sections = [SectionIdentifier]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        delegate = self
        separatorStyle = .none
        
        register(type: MeaningTableViewCell.self)
        diffableDataSource = UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier>(tableView: self, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withType: MeaningTableViewCell.self, for: indexPath)
            cell.configure(with: item.meaning)
            return cell
        })
    }
    
    func update(with cells: [ItemIdentifier]) {
        sections = Array(Set(cells.map({$0.meaning.translation.text})))
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        snapshot.appendSections(sections)
        sections.forEach({ sectionName in
            snapshot.appendItems(cells.filter({$0.meaning.translation.text == sectionName}),
                                 toSection: sectionName)
        })
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension MeaningTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ViewFactory.makeContainerView(usesAutoLayout: false)
        let label = ViewFactory.makeLabel(font: .preferredFont(forTextStyle: .subheadline))
        label.text = "\(section + 1). \(sections[section])"
        view.addSubview(label)
        label.pinEdges(to: view, withInset: 8)
        return view
    }
}

struct MeaningCellInputData: Hashable {
    var meaning: Meaning
}
