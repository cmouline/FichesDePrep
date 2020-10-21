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
    
    lazy var completePrepFiles: Results<PrepFile> = { RealmManager.shared.objects(PrepFile.self).filter("isDraft = false") }()
    lazy var draftPrepFiles: Results<PrepFile> = { RealmManager.shared.objects(PrepFile.self).filter("isDraft = true") }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPDFPreview" {
            let pdfPreviewVC = segue.destination as! PDFPreviewViewController
            let prepFile = sender as! PrepFile
            let generator = PDFGenerator(prepFile: prepFile)
            pdfPreviewVC.documentData = generator.createPDF()            
        }
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

        performSegue(withIdentifier: "showPDFPreview", sender: dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal, title: "Modifier") { (action, view, handler) in
            
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { (_, _, _) in
            let fileCategory = indexPath.section == 0 ? self.completePrepFiles : self.draftPrepFiles
            RealmManager.shared.write {
                RealmManager.shared.delete(fileCategory[indexPath.row])
            }
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }
}
