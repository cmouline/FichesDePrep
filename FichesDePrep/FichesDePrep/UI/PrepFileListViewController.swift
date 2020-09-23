//
//  PrepFileListViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit
import RealmSwift

class PrepFileListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var prepFiles: Results<PrepFile> = { RealmManager.shared.objects(PrepFile.self) }()
    var completePrepFiles: [PrepFile] = []
    var draftPrepFiles: [PrepFile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if prepFiles.isEmpty {
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 1"))
            RealmManager.shared.add(PrepFile(title: "Fiche de preparation test", activityKind: "Arts plastiques", seanceNumber: 2, level: "MS", duration: 20, date: Date(), cycle: 1, mainGoal: "Peindre et faire des collages", specificGoal: "Apprendre à se servir du tube de colle et des tubes de peinture", material: "Colle, pinceaux, peinture", phase: "Regroupement", consigne: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", phaseDuration: "10", teacherRole: "Explique les consignes", pupilRole: "Fais son taf", differenciation: "", isDraft: false))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 2"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 3"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 4"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 5"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 6"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 7"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 8"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 9"))
            RealmManager.shared.add(PrepFile(title: "Fiche de prep 10"))
            
            prepFiles = { RealmManager.shared.objects(PrepFile.self) }()
        }
        completePrepFiles = prepFiles.filter({ !$0.isDraft })
        draftPrepFiles = prepFiles.filter({ $0.isDraft })
    }
}

extension PrepFileListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? completePrepFiles.count : draftPrepFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = indexPath.section == 0 ? completePrepFiles : draftPrepFiles
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "prepCell")
        cell.textLabel?.text = dataSource[indexPath.row].title
        cell.detailTextLabel?.text = dataSource[indexPath.row].creationDate.description(with: Locale.current)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = indexPath.section == 0 ? completePrepFiles : draftPrepFiles

        let generator = PDFGenerator(prepFile: dataSource[indexPath.row])
        let previewVC = PDFPreviewViewController()
        previewVC.documentData = generator.createPDF()
        self.present(previewVC, animated: true, completion: nil)
    }
}
