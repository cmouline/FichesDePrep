//
//  PrepFileFormViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka

class PrepFileFormViewController: FormViewController {
    
    lazy var preferences: Results<Preferences> = { RealmManager.shared.objects(Preferences.self) }()
    var numberOfPhase = 1
    var prepFile: PrepFile? = nil
    var isModifyingFile: Bool = false
    var saveButtonTitle: String = "Enregistrer"
    var saveDraftButtonTitle: String = "Enregistrer comme brouillon"
    
    // MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFormStyle()
        createForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isModifyingFile {
            setPreferedValues()
        }
    }
    
    // MARK:- IBActions
    @IBAction func resetForm(_ sender: Any) {
        for row in form.allRows {
            row.baseValue = nil
        }
        setPreferedValues()
        tableView.reloadData()
    }
    
    // MARK:- Form functions
    private func createForm() {
        form
            +++ Section()
            <<< TextAreaRow() {
                $0.placeholder = "Saisir le titre"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
                $0.tag = "title"
                $0.value = prepFile?.title
            }
            <<< TextAreaRow() {
                $0.placeholder = "Saisir le domaine d'activité"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "activityDomain"
                $0.value = prepFile?.domainActivity
            }
            <<< IntRow() {
                $0.title = "Séance n°"
                $0.placeholder = "1"
                $0.value = prepFile?.sessionNumber
                $0.tag = "sessionNumber"
            }
            <<< PickerInputRow<String>() {
                $0.title = "Niveau"
                $0.options = Const.levels
                $0.tag = "level"
                $0.value = prepFile?.level
            }
            <<< IntRow() {
                $0.title = "Durée (en min)"
                $0.placeholder = "20 min"
                $0.value = prepFile?.duration
                $0.tag = "sessionDuration"
            }
            <<< DateInlineRow() {
                $0.title = "Date de la séance"
                $0.value = prepFile?.date
                let formatter = DateFormatter()
                formatter.locale = .current
                formatter.dateStyle = .long
                $0.dateFormatter = formatter
                $0.tag = "sessionDate"
            }
            <<< IntRow() {
                $0.title = "Cycle"
                $0.placeholder = "1"
                $0.value = prepFile?.cycle
                $0.tag = "cycleNumber"
            }
            
            +++ Section()
            <<< TextAreaRow() {
                $0.placeholder = "Saisir l'objectif général"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "mainGoal"
                $0.value = prepFile?.mainGoal
            }
            <<< TextAreaRow() {
                $0.placeholder = "Saisir l'objectif spécifique"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "specificGoal"
                $0.value = prepFile?.specificGoal
            }
            <<< TextAreaRow() {
                $0.placeholder = "Saisir le matériel"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.tag = "material"
                $0.value = prepFile?.material
            }
        
            if let prepFile = prepFile, let phases = prepFile.phases {
                for (index, phase) in phases.list.enumerated() {
                    form
                    +++ createPhaseSection(index + 1, data: phase)
                }
            } else {
                form
                +++ createPhaseSection(1)
            }

            form
            +++ Section()
                <<< ButtonRow() {
                    $0.title = saveDraftButtonTitle
                }
                .cellSetup({ cell, row in
                    cell.backgroundColor = UIColor(named: "lightPurple")
                    cell.tintColor = .white
                })
                .onCellSelection { _, _ in
                    self.savePrepFile(asDraft: true)
                }
                <<< ButtonRow() {
                    $0.title = saveButtonTitle
                }
                .cellSetup({ cell, row in
                    cell.backgroundColor = UIColor(named: "darkPurple")
                    cell.tintColor = .white
                })
                .onCellSelection { _, _ in
                    self.savePrepFile(asDraft: false)
                }
    }
    
    private func createPhaseSection(_ number: Int, data: Phase? = nil) -> Section {
        let newSection = Section("Phase n°\(number)")
            <<< TextAreaRow() {
                $0.tag = "consigne-\(number)"
                $0.placeholder = "Consignes"
                if let data = data {
                    $0.value = data.consigne
                }
            }
            <<< IntRow() {
                $0.tag = "phaseDuration-\(number)"
                $0.title = "Durée (en min)"
                $0.placeholder = "5 min"
                if let data = data {
                    $0.value = data.phaseDuration
                }
            }
            <<< TextAreaRow() {
                $0.tag = "teacherRole-\(number)"
                $0.placeholder = "Rôle de l'enseignant"
                if let data = data {
                    $0.value = data.teacherRole
                }
            }
            <<< TextAreaRow() {
                $0.tag = "pupilRole-\(number)"
                $0.placeholder = "Rôle de l'élève"
                if let data = data {
                    $0.value = data.pupilRole
                }
            }
            <<< TextAreaRow() {
                $0.tag = "differenciation-\(number)"
                $0.placeholder = "Différenciation"
                if let data = data {
                    $0.value = data.differenciation
                }
            }
        newSection
            <<< ButtonRow() {
                $0.title = "Ajouter phase"
            }.onCellSelection { _, row in
                self.addPhaseToForm(on: row)
            }
        return newSection
    }
    
    private func addPhaseToForm(on row: ButtonRow) {
        numberOfPhase += 1
        form.insert(createPhaseSection(numberOfPhase),
                    at: form.allSections.count - 1)
    }
    
    private func setFormStyle() {
        let ATFont = UIFont(name: "AmericanTypewriter", size: 18)
        
        TextAreaRow.defaultCellSetup = { cell, row in
            cell.placeholderLabel?.font = ATFont
            cell.textView?.font = ATFont
        }
        IntRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = ATFont
        }
        IntRow.defaultCellUpdate = { cell, row in
            cell.textField.font = ATFont
        }
        ButtonRow.defaultCellSetup = { cell, row in cell.textLabel?.font = ATFont }
        DateInlineRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = ATFont
            cell.detailTextLabel?.font = ATFont
        }
        DateInlineRow.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = ATFont
        }
        DateInlineRow.InlineRow.defaultRowInitializer = { row in
            let frLocale = Locale(identifier: "fr_FR")
            var calendar = Calendar(identifier: .iso8601)
            calendar.locale = frLocale
            row.cell.datePicker.locale = frLocale
            row.cell.datePicker.calendar = calendar
        }
        PickerInputRow<String>.defaultCellSetup = { cell, row in
            cell.textLabel?.font = ATFont
        }
        PickerInputRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = ATFont
        }
    }

    // MARK:- Set and save form values
    private func setPreferedValues() {
        if let preferedLevel = preferences.first?.level {
            form.rowBy(tag: "level")?.baseValue = preferedLevel
        }
        if let preferedCycle = preferences.first?.cycle {
            form.rowBy(tag: "cycleNumber")?.baseValue = preferedCycle
        }
    }
    
    private func savePrepFile(asDraft: Bool) {
        let values = self.form.values()
        RealmManager.shared.write {
            if isModifyingFile {
                prepFile?.title = values["title"] as? String ?? ""
                prepFile?.domainActivity = values["activityDomain"] as? String ?? ""
                prepFile?.sessionNumber = values["sessionNumber"] as? Int ?? 0
                prepFile?.level = values["level"] as? String ?? ""
                prepFile?.duration = values["sessionDuration"] as? Int ?? 0
                prepFile?.date = values["sessionDate"] as? Date ?? Date()
                prepFile?.cycle = values["cycleNumber"] as? Int ?? 0
                prepFile?.mainGoal = values["mainGoal"] as? String ?? ""
                prepFile?.specificGoal = values["specificGoal"] as? String ?? ""
                prepFile?.material = values["material"] as? String ?? ""
                prepFile?.phases = PhaseList(list: self.getPhasesData())
                prepFile?.isDraft = asDraft
            } else {
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
                                            isDraft: asDraft))
            }
        }
        if isModifyingFile {
            let parent = (self.presentingViewController as? UITabBarController)?.selectedViewController as? PrepFileListViewController
            self.dismiss(animated: true) {
                parent?.updateTableview()
            }
        } else {
            resetForm("")
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }

    private func getPhasesData() -> [Phase] {
        var phases: [Phase] = []
        let values = self.form.values()
        for index in 1...numberOfPhase {
            phases.append(Phase(
                            phaseNumber: index,
                            consigne: values["consigne-\(index)"] as? String,
                            phaseDuration: values["phaseDuration-\(index)"] as? Int,
                            teacherRole: values["teacherRole-\(index)"] as? String,
                            pupilRole: values["pupilRole-\(index)"] as? String,
                            differenciation: values["differenciation-\(index)"] as? String)
            )
        }
        return phases
    }
}
