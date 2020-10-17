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
    var numberOfPhase = 1
    
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
        
            +++ createPhaseSection(1, withRemoveButton: false)

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
                                                phases: self.getPhasesData(),
                                                isDraft: false))
                }
            }
    }
    
    func createPhaseSection(_ number: Int, withRemoveButton: Bool = true) -> Section {
        let newSection = Section("Phase n°\(number)")
            <<< TextAreaRow() {
                $0.tag = "consigne-\(number)"
                $0.placeholder = "Consignes"
            }
            <<< IntRow() {
                $0.tag = "phaseDuration-\(number)"
                $0.title = "Durée"
                $0.placeholder = "5mn"
            }
            <<< TextAreaRow() {
                $0.tag = "teacherRole-\(number)"
                $0.placeholder = "Rôle de l'enseignant"
            }
            <<< TextAreaRow() {
                $0.tag = "pupilRole-\(number)"
                $0.placeholder = "Rôle de l'élève"
            }
            <<< TextAreaRow() {
                $0.tag = "differenciation-\(number)"
                $0.placeholder = "Différenciation"
            }
        if withRemoveButton {
            newSection
                <<< ButtonRow() {
                    $0.title = "Effacer phase"
                }.onCellSelection { _, row in
                    if let section = row.section, let index = section.index {
                        self.numberOfPhase -= 1
                        self.form.allSections[index].removeAll()
                        self.form.remove(at: index)
                        self.reSetPhaseNumber()
                    }
                }
        }
        newSection
            <<< ButtonRow() {
                $0.title = "Ajouter phase"
            }.onCellSelection { _, row in
                self.addPhase(on: row)
            }
        return newSection
    }
    
    private func addPhase(_ number: Int? = nil, on row: ButtonRow) {
        if let section = row.section, let index = section.index {
            self.numberOfPhase += 1
            let phaseNumber = number == nil ? self.numberOfPhase : number!
            self.form.insert(self.createPhaseSection(phaseNumber), at: index + 1)
            self.reSetPhaseNumber()
        }
    }
    
    private func reSetPhaseNumber() {
        for index in 1...numberOfPhase {
            let section = form.allSections[1 + index]
            section.header?.title = "Phase n°\(index)"
            section.allRows[0].tag = "consigne-\(index)"
            section.allRows[1].tag = "phaseDuration-\(index)"
            section.allRows[2].tag = "teacherRole-\(index)"
            section.allRows[3].tag = "pupilRole-\(index)"
            section.allRows[4].tag = "differenciation-\(index)"
        }
        tableView.reloadData()
    }
    
    private func getPhasesData() -> [Phase] {
        var phases: [Phase] = []
        let values = self.form.values()
        for index in 1...numberOfPhase {
            if let consigne = values["consigne-\(index)"] as? String,
               let phaseDuration = values["phaseDuration-\(index)"] as? Int,
               let teacherRole = values["teacherRole-\(index)"] as? String,
               let pupilRole = values["pupilRole-\(index)"] as? String,
               let differenciation = values["differenciation-\(index)"] as? String {
                phases.append(Phase(
                                phaseNumber: index,
                                consigne: consigne,
                                phaseDuration: phaseDuration,
                                teacherRole: teacherRole,
                                pupilRole: pupilRole,
                                differenciation: differenciation)
                )
            }
        }
        return phases
    }
}
