//
//  SettingsViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 23/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let titles: [String] = ["Niveau", "Cycle"]
    var levels: [String] = ["PS", "MS", "GS", "CP", "CE1", "CE2", "CM1", "CM2"]

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "settingCell")
        tableView.register(SettingPickerCell.self, forCellReuseIdentifier: "settingPickerCell")
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellType: CellType? = nil
        
        switch indexPath.row {
        case 0:
            cellType = .picker
        case 1:
            cellType = .textViewNum
        default:
            cellType = nil
        }
        
        if let type = cellType {
            if type == .picker, let cell = tableView.dequeueReusableCell(withIdentifier: "settingPickerCell", for: indexPath) as? SettingPickerCell {
                cell.setTitle(titles[indexPath.row])
                cell.levels = levels
                cell.currentIndexPath = indexPath
                cell.picker.reloadAllComponents()
                NotificationCenter.default.addObserver(self, selector: #selector(updateCellSize(_:)), name: NSNotification.Name(rawValue: "updateCellSize"), object: nil)
                return cell
            } else if type == .textViewNum, let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as? SettingCell {
                cell.setTitle(titles[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @objc func updateCellSize(_ notification: Notification) {
        let userInfo = notification.userInfo
        if let index = userInfo?["indexPath"] as? IndexPath {
            tableView.reloadRows(at: [index], with: .automatic)
        }
    }
}
