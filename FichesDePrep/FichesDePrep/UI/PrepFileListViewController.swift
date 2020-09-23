//
//  PrepFileListViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

class PrepFileListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var prepFiles: [PrepFile] = [
        PrepFile(title: "Fiche de prep 1"),
        PrepFile(title: "Fiche de preparation test", activityKind: "Arts plastiques", seanceNumber: 2, level: "MS", duration: 20, date: Date(), cycle: 1, mainGoal: "Peindre et faire des collages", specificGoal: "Apprendre à se servir du tube de colle et des tubes de peinture", material: "Colle, pinceaux, peinture", phase: "Regroupement", consigne: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", phaseDuration: "10", teacherRole: "Explique les consignes", pupilRole: "Fais son taf", differenciation: ""),
        PrepFile(title: "Fiche de prep 2"),
        PrepFile(title: "Fiche de prep 3"),
        PrepFile(title: "Fiche de prep 4"),
        PrepFile(title: "Fiche de prep 5"),
        PrepFile(title: "Fiche de prep 6"),
        PrepFile(title: "Fiche de prep 7"),
        PrepFile(title: "Fiche de prep 8"),
        PrepFile(title: "Fiche de prep 9"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PrepFileListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prepFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "prepCell")
        cell.textLabel?.text = prepFiles[indexPath.row].title
        cell.detailTextLabel?.text = prepFiles[indexPath.row].creationDate.description(with: Locale.current)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = PDFGenerator(prepFile: prepFiles[indexPath.row])
        let previewVC = PDFPreviewViewController()
        previewVC.documentData = generator.createPDF()
        self.present(previewVC, animated: true, completion: nil)
    }
}
