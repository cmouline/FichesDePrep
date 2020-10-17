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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepFiles = RealmManager.shared.objects(PrepFile.self)
        completePrepFiles = prepFiles.filter({ !$0.isDraft })
        draftPrepFiles = prepFiles.filter({ $0.isDraft })
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
}
