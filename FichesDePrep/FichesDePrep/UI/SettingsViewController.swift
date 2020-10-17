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

class SettingsViewController: FormViewController {
    
    var levels: [String] = ["PS", "MS", "GS", "CP", "CE1", "CE2", "CM1", "CM2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
            <<< PickerInputRow<String>() {
                $0.title = "Niveau"
                $0.options = levels
                $0.value = $0.options.first
                $0.tag = "level"
            }
            <<< IntRow() {
                $0.title = "Cycle"
                $0.placeholder = "1"
                $0.tag = "cycle"
            }
        
        BMCManager.shared.presentingViewController = self
        BMCManager.shared.thankYouMessage = "Merci du soutien, à moi la pizza ! 🍕🎉 Chloë"
    }
}
