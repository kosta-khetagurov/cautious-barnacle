//
//  AutoLayoutExtensions.swift
//  lexicon
//
//  Created by Konstantin Khetagurov on 13.03.2021.
//

import UIKit

extension UIView {
    func pinEdges(to view: UIView, withInset constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: constant),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constant),
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant)
        ])
    }
}
