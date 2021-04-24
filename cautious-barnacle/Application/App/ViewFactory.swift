//
//  ViewFactory.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import UIKit

class ViewFactory {
    static func makeContainerView(usesAutoLayout: Bool = true, backgroundColor: UIColor = .systemBackground, cornerRadius: CGFloat = 10) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
        view.backgroundColor = backgroundColor
        return view
    }
    
    static func makeLabel(usesAutoLayout: Bool = true, textColor: UIColor = .label, font: UIFont, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
        return label
    }
    
    static func makeTextView(usesAutoLayout: Bool = true, textColor: UIColor = .label, font: UIFont) -> UITextView {
        let textView = UITextView()
        textView.textColor = textColor
        textView.font = font
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
        return textView
    }
    
    static func makeErrorView(with error: WordsError) -> UIView {
        let view = ViewFactory.makeContainerView()
        let label = ViewFactory.makeLabel(font: .preferredFont(forTextStyle:.body))
        view.addSubview(label)
    
        label.text = error.errorDescription
        label.pinEdges(to: view)
        return view
    }
}
