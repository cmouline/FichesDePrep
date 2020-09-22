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
}
