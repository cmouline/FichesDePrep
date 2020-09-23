//
//  PDFPreviewViewController.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 23/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import PDFKit

class PDFPreviewViewController: UIViewController {
    public var documentData: Data?
    var pdfView: PDFView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
        
        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }
}
