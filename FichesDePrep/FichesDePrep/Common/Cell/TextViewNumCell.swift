//
//  TextViewNumCell.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

class TextViewNumCell: CommonCell {
    
    var textView: UITextView = UITextView()
    
    override func setup() {
        super.setup()
        textView.keyboardType = .numberPad
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        
        contentView.removeConstraint(bottomConstraint)
        contentView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        ])
    }
}
