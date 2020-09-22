//
//  DatePickerCell.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

class DatePickerCell: CommonCell {
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    override func setup() {
        super.setup()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        contentView.addSubview(datePicker)
        
        contentView.removeConstraint(bottomConstraint)
        contentView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: datePicker, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: datePicker, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: datePicker, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: datePicker, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150)
        ])
    }
}
