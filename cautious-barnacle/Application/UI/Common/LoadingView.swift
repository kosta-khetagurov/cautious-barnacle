//
//  LoadingView.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 24.05.2021.
//

import UIKit

class LoadingView: UIView {
    
    private let spinner = UIActivityIndicatorView(style: .large)

    override var isHidden: Bool {
        didSet {
            if isHidden {
                spinner.stopAnimating()
            } else {
                spinner.startAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        
        spinner.pinEdges(to: self)
    }
}

