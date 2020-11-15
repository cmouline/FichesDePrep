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
    @IBOutlet weak var noPrepFileView: UIView!
    
    lazy var completePrepFiles: Results<PrepFile> = { RealmManager.shared.objects(PrepFile.self).filter("isDraft = false").sorted(byKeyPath: "date", ascending: false) }()
    lazy var draftPrepFiles: Results<PrepFile> = { RealmManager.shared.objects(PrepFile.self).filter("isDraft = true").sorted(byKeyPath: "lastModificationDate", ascending: false) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPDFPreview" {
            let pdfPreviewVC = segue.destination as! PDFPreviewViewController
            let prepFile = sender as! PrepFile
            let generator = PDFGenerator(prepFile: prepFile)
            pdfPreviewVC.prepFile = prepFile
            pdfPreviewVC.documentData = generator.createPDF()            
        }
    }
    
    func updateTableview() {
        completePrepFiles = { RealmManager.shared.objects(PrepFile.self).filter("isDraft = false").sorted(byKeyPath: "date", ascending: false) }()
        draftPrepFiles = { RealmManager.shared.objects(PrepFile.self).filter("isDraft = true").sorted(byKeyPath: "lastModificationDate", ascending: false) }()
        noPrepFileView.isHidden = !(completePrepFiles.count == 0 && draftPrepFiles.count == 0)
        tableView.reloadData()
    }
}

extension PrepFileListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Fiches" : "Brouillons"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? completePrepFiles.count : draftPrepFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = indexPath.section == 0 ? completePrepFiles : draftPrepFiles
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "prepCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = dataSource[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "AmericanTypewriter", size: 17)
        cell.detailTextLabel?.text = "Séance du " + Util.formatDate(dataSource[indexPath.row].date)
        cell.detailTextLabel?.font = UIFont(name: "AmericanTypewriter-Light", size: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = indexPath.section == 0 ? completePrepFiles : draftPrepFiles

        performSegue(withIdentifier: "showPDFPreview", sender: dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let duplicateAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            let fileCategory = indexPath.section == 0 ? self.completePrepFiles : self.draftPrepFiles
            let fileToCopy: PrepFile = fileCategory[indexPath.row]
            let copyPrepFile: PrepFile = PrepFile(title: "Copie de \(fileToCopy.title)",
                                        activityKind: fileToCopy.domainActivity,
                                        seanceNumber: fileToCopy.sessionNumber,
                                        level: fileToCopy.level,
                                        duration: fileToCopy.duration,
                                        date: fileToCopy.date,
                                        cycle: fileToCopy.cycle,
                                        mainGoal: fileToCopy.mainGoal,
                                        specificGoal: fileToCopy.specificGoal,
                                        material: fileToCopy.material,
                                        phases: fileToCopy.phases ?? PhaseList(),
                                        isDraft: fileToCopy.isDraft)
            RealmManager.shared.write {
                RealmManager.shared.add(copyPrepFile)
            }
            completionHandler(true)
            self.tableView.reloadData()
        }
        duplicateAction.image = UIImage(systemName: "doc.on.doc")
        duplicateAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [duplicateAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let updateAction = UIContextualAction(style: .normal, title: "Modifier") { (_, _, completionHandler) in
            let fileCategory = indexPath.section == 0 ? self.completePrepFiles : self.draftPrepFiles
            let prepFormVC = PrepFileFormViewController()
            prepFormVC.prepFile = fileCategory[indexPath.row]
            prepFormVC.isModifyingFile = true
            prepFormVC.saveDraftButtonTitle = "Garder en brouillon"
            prepFormVC.saveButtonTitle = "Terminer"
            self.present(prepFormVC, animated: true, completion: nil)
            completionHandler(true)
        }
        updateAction.image = UIImage(systemName: "pencil")
        updateAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            let fileCategory = indexPath.section == 0 ? self.completePrepFiles : self.draftPrepFiles
            let alert = UIAlertController(title: "Supprimer", message: "Voulez vous supprimer cette fiche ?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Supprimer", style: .destructive) { _ in
                RealmManager.shared.write {
                    RealmManager.shared.delete(fileCategory[indexPath.row])
                }
                completionHandler(true)
                self.updateTableview()
            }
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in 
                completionHandler(true)
            }
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }
}
