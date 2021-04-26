//
//  MeaningTableViewCell.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 26.04.2021.
//

import UIKit
import Kingfisher

class MeaningTableViewCell: UITableViewCell {
    private var picture = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
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
