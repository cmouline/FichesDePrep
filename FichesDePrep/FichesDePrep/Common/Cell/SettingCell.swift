//
//  SettingCell.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 23/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    var titleLabel: UILabel = UILabel()
    var selectSwitch: UISwitch = UISwitch()
    var bottomConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectSwitch)

        bottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -8)
        contentView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 32),
            bottomConstraint,
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: selectSwitch, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: selectSwitch, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectSwitch, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -16),
        ])
        
        selectSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    @objc func switchAction(_ sender: UISwitch) {
        // Implement in child class
    }
}

class SettingPickerCell: SettingCell {
    
    var picker: UIPickerView = UIPickerView()
    var heightConstraint: NSLayoutConstraint!
    var levels: [String] = []
    var currentIndexPath: IndexPath?
    
    override func setup() {
        super.setup()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        contentView.addSubview(picker)

        contentView.removeConstraint(bottomConstraint)
        heightConstraint = NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150)
        contentView.addConstraints([
            NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: picker, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -8),
            heightConstraint
        ])
    }
    
    override func switchAction(_ sender: UISwitch) {
        contentView.removeConstraint(heightConstraint)
        heightConstraint = NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: sender.isOn ? 150 : 0)
        contentView.addConstraint(heightConstraint)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCellSize"), object: nil, userInfo: ["indexPath": currentIndexPath!])
        layoutSubviews()
    }
}

extension SettingPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

