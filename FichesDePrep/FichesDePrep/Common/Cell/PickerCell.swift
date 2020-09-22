//
//  PickerCell.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

class PickerCell: CommonCell {
    
    var picker: UIPickerView = UIPickerView()
    var levels: [String] = []
    
    override func setup() {
        super.setup()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        contentView.addSubview(picker)
        
        contentView.removeConstraint(bottomConstraint)
        contentView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: picker, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: picker, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150)
        ])
    }
}

extension PickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levels[row]
    }
}
