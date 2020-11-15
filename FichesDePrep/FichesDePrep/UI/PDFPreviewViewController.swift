//
//  PDFPreviewViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 23/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import PDFKit

class PDFPreviewViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    public var prepFile: PrepFile?
    public var documentData: Data?
    private var pdfDoc: PDFDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = documentData {
            pdfDoc = PDFDocument(data: data)
            pdfView.document = pdfDoc
            pdfView.autoScales = true
        }
    }
    
    @IBAction func phaseOrganizingAction(_ sender: Any) {
        let alert = UIAlertController(title: "Voulez vous supprimer la dernière phase ?", message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Supprimer", style: .destructive, handler: { _ in
            RealmManager.shared.write {
                self.prepFile?.phases?.list.removeLast()
            }
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let activityViewController =
            UIActivityViewController(activityItems: [documentData],
                                     applicationActivities: [])

        present(activityViewController, animated: true)
    }
}
