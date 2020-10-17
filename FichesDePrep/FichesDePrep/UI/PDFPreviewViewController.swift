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
    
    @IBAction func shareAction(_ sender: Any) {
        let activityViewController =
            UIActivityViewController(activityItems: [documentData],
                                     applicationActivities: [])

        present(activityViewController, animated: true)
    }
}
