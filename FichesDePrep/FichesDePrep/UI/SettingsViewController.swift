//
//  SettingsViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 23/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit
import Eureka
import BuyMeACoffee
import RealmSwift

class SettingsViewController: FormViewController {
    
    var levels: [String] = ["PS", "MS", "GS", "CP", "CE1", "CE2", "CM1", "CM2"]
    lazy var preferences: Results<Preferences> = { RealmManager.shared.objects(Preferences.self) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
            <<< PickerInputRow<String>() {
                $0.title = "Niveau"
                $0.options = levels
                $0.value = preferences[0].level ?? levels[0]
                $0.tag = "level"
            }.onRowValidationChanged({ cell, row in
                self.savePreferences(for: row.tag, row.value as Any)
            })
            <<< IntRow() {
                $0.title = "Cycle"
                $0.placeholder = "1"
                $0.value = preferences[0].cycle - 1
                $0.tag = "cycle"
            }.onRowValidationChanged({ cell, row in
                self.savePreferences(for: row.tag, row.value as Any)
            })
        
        BMCManager.shared.presentingViewController = self
        BMCManager.shared.thankYouMessage = "Merci du soutien, à moi la pizza ! 🍕🎉 Chloë"
    }
    
    private func savePreferences(for tag: String?, _ value: Any) {
        guard let tag = tag else { return }
        
        RealmManager.shared.write {
            switch tag {
            case "level":
                preferences.first?.level = value as? String
            case "cycle":
                if let cycle = value as? Int {
                    preferences.first?.cycle = cycle
                }
            default:
                return
            }
        }
    }
}
