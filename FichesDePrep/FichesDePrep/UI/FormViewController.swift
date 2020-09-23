//
//  FormViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cellTitles: [[String]] = [
        ["Domaines d'activité", "Séance numéro", "Niveau", "Durée", "Date", "Cycle"],
        ["Objectif général", "Objectif spécifique", "Matériel"],
        ["Phase", "Consigne", "Durée", "Rôle de l'enseignant", "Rôle de l'élève", "Différenciation"],
        ["GÉNÉRER"]
    ]
    var levels: [String] = ["PS", "MS", "GS", "CP", "CE1", "CE2", "CM1", "CM2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextViewTextCell.self, forCellReuseIdentifier: "textViewTextCell")
        tableView.register(TextViewNumCell.self, forCellReuseIdentifier: "textViewNumCell")
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: "datePickerCell")
        tableView.register(PickerCell.self, forCellReuseIdentifier: "pickerCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "buttonCell")
        tableView.estimatedRowHeight = 132
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 6
        case 1:
            return 3
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellType: CellType? = nil
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cellType = .textViewText
            case 1, 3, 5:
                cellType = .textViewNum
            case 2:
                cellType = .picker
            case 4:
                cellType = .datePicker
            default:
                cellType = nil
            }
        case 1:
            cellType = .textViewText
        case 2:
            switch indexPath.row {
            case 0, 1, 3, 4, 5:
                cellType = .textViewText
            case 2:
                cellType = .textViewNum
            default:
                cellType = nil
            }
        case 3:
            cellType = .button
        default:
            cellType = nil
        }
        
        if let type = cellType {
            if type == .textViewText, let cell = tableView.dequeueReusableCell(withIdentifier: "textViewTextCell", for: indexPath) as? TextViewTextCell {
                cell.setTitle(cellTitles[indexPath.section][indexPath.row])
                return cell
            } else if type == .textViewNum, let cell = tableView.dequeueReusableCell(withIdentifier: "textViewNumCell", for: indexPath) as? TextViewNumCell {
                cell.setTitle(cellTitles[indexPath.section][indexPath.row])
                return cell
            } else if type == .datePicker, let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as? DatePickerCell {
                cell.setTitle(cellTitles[indexPath.section][indexPath.row])
                return cell
            } else if type == .picker, let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerCell {
                cell.setTitle(cellTitles[indexPath.section][indexPath.row])
                cell.levels = levels
                cell.picker.reloadAllComponents()
                cell.layoutSubviews()
                return cell
            } else if type == .button, let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonCell {
                cell.setTitle(cellTitles[indexPath.section][indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}

enum CellType {
    case textViewText
    case textViewNum
    case picker
    case datePicker
    case button
}

