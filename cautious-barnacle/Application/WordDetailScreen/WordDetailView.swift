//
//  WordDetailView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit
import Kingfisher

protocol WordDetailView: UIView {
    func update(with: MeaningInputData)
}

class WordDetailViewImp: UIView, WordDetailView {
    var tableView: MeaningTableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        tableView = MeaningTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.pinEdges(to: self)
    }
    
    func update(with data: MeaningInputData) {
        tableView.update(with: data.meaningCellInputData)
    }
}

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

class MeaningTableViewCell: UITableViewCell {
    var picture = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    private func setup() {
        picture.clipsToBounds = true
        picture.contentMode = .scaleAspectFit
        picture.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(picture)
        
        var constraints = picture.pinEdgesConstraints(to: contentView)
        constraints.append(picture.heightAnchor.constraint(equalToConstant: 150))
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with meaning: Meaning) {
        if let image = meaning.images.first, let url = URL(string: "https:\(image.url)"){
            picture.kf.setImage(with: url, placeholder: UIImage(named: "photo.fill"))
        }
    }
}
