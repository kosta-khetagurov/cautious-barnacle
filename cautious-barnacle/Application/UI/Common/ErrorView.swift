//
//  ErrorView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 26.04.2021.
//

import UIKit

class ErrorView: UIView {
    
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        label = ViewFactory.makeLabel(font: .preferredFont(forTextStyle: .body))
        label.textAlignment = .center
        addSubview(label)
        label.pinEdges(to: self)
    }
    
    func update(with text: String) {
        label.text = text
    }
}

