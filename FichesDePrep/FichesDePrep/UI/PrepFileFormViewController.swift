//
//  PrepFileFormViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit
import Eureka

class PrepFileFormViewController: FormViewController {
    
    var levels: [String] = ["PS", "MS", "GS", "CP", "CE1", "CE2", "CM1", "CM2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        form
            +++ Section()
            <<< TextAreaRow() {
                $0.placeholder = "Saisir le titre"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
                $0.tag = "title"
            }
            <<< TextAreaRow() {
                $0.placeholder = "Saisir le domaine d'activité"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "activityDomain"
            }
            <<< IntRow() {
                $0.title = "Séance n°"
                $0.placeholder = "1"
                $0.value = nil
                $0.tag = "sessionNumber"
            }
            <<< PickerInputRow<String>() {
                $0.title = "Niveau"
                $0.options = levels
                $0.value = $0.options.first
                $0.tag = "level"
            }
            <<< IntRow() {
                $0.title = "Durée (en min)"
                $0.placeholder = "5"
                $0.value = nil
                $0.tag = "sessionDuration"
           }
            <<< DateInlineRow() {
                $0.title = "Date de la séance"
                $0.value = Date()
                let formatter = DateFormatter()
                formatter.locale = .current
                formatter.dateStyle = .long
                $0.dateFormatter = formatter
                $0.tag = "sessionDate"
            }
            <<< IntRow() {
                $0.title = "Cycle"
                $0.placeholder = "1"
                $0.value = nil
                $0.tag = "cycleNumber"
            }
        
            +++ Section()
            <<< TextAreaRow() {
                $0.placeholder = "Saisir l'objectif général"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "mainGoal"
            }
            <<< TextAreaRow() {
                $0.placeholder = "Saisir l'objectif spécifique"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "specificGoal"
            }
            <<< TextAreaRow() {
                $0.placeholder = "Saisir le matériel"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "material"
            }

            +++ Section()
            <<< ButtonRow() {
                $0.title = "Enregistrer"
            }
            .onCellSelection { _, _ in
                let values = self.form.values()
                RealmManager.shared.write {
                    RealmManager.shared.add(PrepFile(
                                                title: values["title"] as? String,
                                                activityKind: values["activityDomain"] as? String,
                                                seanceNumber: values["sessionNumber"] as? Int,
                                                level: values["level"] as? String,
                                                duration: values["sessionDuration"] as? Int,
                                                date: values["sessionDate"] as? Date,
                                                cycle: values["cycleNumber"] as? Int,
                                                mainGoal: values["mainGoal"] as? String,
                                                specificGoal: values["specificGoal"] as? String,
                                                material: values["material"] as? String,
                                                phases: [],
                                                isDraft: false))
                }
            }
    }
}

enum CellType {
    case textViewText
    case textViewNum
    case picker
    case datePicker
    case button
}
