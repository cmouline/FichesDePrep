//
//  PhaseFormViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 13/10/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit
import Eureka

class PhaseFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        form
        +++ Section("Phase 1")
            <<< IntRow() {
                $0.title = "Phase n°"
                $0.value = 1
                $0.tag = "phaseNumber"
            }
            <<< TextAreaRow() {
                $0.title = "Consigne"
                $0.placeholder = "Consigne"
                $0.tag = "consigne"
            }
            <<< IntRow() {
                $0.title = "Durée"
                $0.placeholder = "5"
                $0.tag = "consigne"
            }
    }
}
