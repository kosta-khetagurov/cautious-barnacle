//
//  WordTableViewCell.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

class WordTableViewCell: UITableViewCell, IdentifiableView {
    
    private lazy var nameLabel: UILabel = ViewFactory.makeLabel(font: .preferredFont(forTextStyle: .title3))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup() {
        contentView.addSubview(nameLabel)
        
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nameLabel.pinEdges(to: contentView, withInset: 8)
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(with word: Word) {
        nameLabel.text = word.name
    }
}
