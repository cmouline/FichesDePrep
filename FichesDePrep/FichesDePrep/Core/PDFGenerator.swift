//
//  PDFGenerator.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit
import PDFKit

class PDFGenerator {
    
    var prepFileData: PrepFile
    
    init(prepFile: PrepFile) {
        prepFileData = prepFile
    }
    
    func createPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Fiches de Prep",
            kCGPDFContextAuthor: "cmoulinet.com"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 11 * 72.0
        let pageHeight = 8.5 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let domainBottom = addText(pageRect: pageRect, withText: "Domaine: \(prepFileData.activityKind)")
            let seanceNumberBottom = addText(pageRect: pageRect, withText: "Séance numéro: \(prepFileData.seanceNumber)", under: domainBottom)
            let levelBottom = addText(pageRect: pageRect, withText: "Niveau: \(prepFileData.level)", under: seanceNumberBottom)
            let durationBottom = addText(pageRect: pageRect, withText: "Durée: \(prepFileData.duration)min", under: levelBottom)
            let mainGoalBottom = addText(pageRect: pageRect, withText: "Objectif général: \(prepFileData.mainGoal)", under: durationBottom)
            let specificGoalBottom = addText(pageRect: pageRect, withText: "Objectif spécifique: \(prepFileData.specificGoal)", under: mainGoalBottom)
            let materialBottom = addText(pageRect: pageRect, withText: "Matériel: \(prepFileData.material)", under: specificGoalBottom)

            _ = addText(pageRect: pageRect, withText: "Phase: \(prepFileData.phase)", under: materialBottom)
        }
        
        return data
    }
    
    func addText(pageRect: CGRect, withText text: String, under bottomPosition: CGFloat? = nil, next rightPosition: CGFloat? = nil) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        let domainAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: textFont]
        let attributedText = NSAttributedString(string: text, attributes: domainAttributes)
        let textStringSize = attributedText.size()
        var yBase: CGFloat = 36
        var xBase: CGFloat = 36
        if let bottom = bottomPosition {
            yBase = bottom
        }
        if let right = rightPosition {
            xBase = right
        }
        let textStringRect = CGRect(x: xBase,
                                    y: yBase,
                                    width: pageRect.width - (36 * 2),
                                    height: textStringSize.height)
        
        attributedText.draw(in: textStringRect)
        return textStringRect.origin.y + textStringRect.size.height
    }

    
    // ---------------------------------------------
    
//    func addTitle(pageRect: CGRect) -> CGFloat {
//        // 1
//        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
//        // 2
//        let titleAttributes: [NSAttributedString.Key: Any] =
//            [NSAttributedString.Key.font: titleFont]
//        let attributedTitle = NSAttributedString(string: prepFileData.title, attributes: titleAttributes)
//        // 3
//        let titleStringSize = attributedTitle.size()
//        // 4
//        let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
//                                     y: 36, width: titleStringSize.width,
//                                     height: titleStringSize.height)
//        // 5
//        attributedTitle.draw(in: titleStringRect)
//        // 6
//        return titleStringRect.origin.y + titleStringRect.size.height
//    }
//
//    func addBodyText(pageRect: CGRect, textTop: CGFloat) {
//        // 1
//        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
//        // 2
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .natural
//        paragraphStyle.lineBreakMode = .byWordWrapping
//        // 3
//        let textAttributes = [
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//            NSAttributedString.Key.font: textFont
//        ]
//        let attributedText = NSAttributedString(string: body, attributes: textAttributes)
//        // 4
//        let textRect = CGRect(x: 10, y: textTop, width: pageRect.width - 20,
//                              height: pageRect.height - textTop - pageRect.height / 5.0)
//        attributedText.draw(in: textRect)
//    }
//
//    func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
//        // 1
//        let maxHeight = pageRect.height * 0.4
//        let maxWidth = pageRect.width * 0.8
//        // 2
//        let aspectWidth = maxWidth / image.size.width
//        let aspectHeight = maxHeight / image.size.height
//        let aspectRatio = min(aspectWidth, aspectHeight)
//        // 3
//        let scaledWidth = image.size.width * aspectRatio
//        let scaledHeight = image.size.height * aspectRatio
//        // 4
//        let imageX = (pageRect.width - scaledWidth) / 2.0
//        let imageRect = CGRect(x: imageX, y: imageTop,
//                               width: scaledWidth, height: scaledHeight)
//        // 5
//        image.draw(in: imageRect)
//        return imageRect.origin.y + imageRect.size.height
//    }
//
//    // 1
//    func drawTearOffs(_ drawContext: CGContext, pageRect: CGRect,
//                      tearOffY: CGFloat, numberTabs: Int) {
//        // 2
//        drawContext.saveGState()
//        drawContext.setLineWidth(2.0)
//
//        // 3
//        drawContext.move(to: CGPoint(x: 0, y: tearOffY))
//        drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
//        drawContext.strokePath()
//        drawContext.restoreGState()
//
//        // 4
//        drawContext.saveGState()
//        let dashLength = CGFloat(72.0 * 0.2)
//        drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
//        // 5
//        let tabWidth = pageRect.width / CGFloat(numberTabs)
//        for tearOffIndex in 1..<numberTabs {
//            // 6
//            let tabX = CGFloat(tearOffIndex) * tabWidth
//            drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
//            drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
//            drawContext.strokePath()
//        }
//        // 7
//        drawContext.restoreGState()
//    }
//
//    func drawContactLabels(_ drawContext: CGContext, pageRect: CGRect, numberTabs: Int) {
//        let contactTextFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .natural
//        paragraphStyle.lineBreakMode = .byWordWrapping
//        let contactBlurbAttributes = [
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//            NSAttributedString.Key.font: contactTextFont
//        ]
//        let attributedContactText = NSMutableAttributedString(string: contactInfo, attributes: contactBlurbAttributes)
//        // 1
//        let textHeight = attributedContactText.size().height
//        let tabWidth = pageRect.width / CGFloat(numberTabs)
//        let horizontalOffset = (tabWidth - textHeight) / 2.0
//        drawContext.saveGState()
//        // 2
//        drawContext.rotate(by: -90.0 * CGFloat.pi / 180.0)
//        for tearOffIndex in 0...numberTabs {
//            let tabX = CGFloat(tearOffIndex) * tabWidth + horizontalOffset
//            // 3
//            attributedContactText.draw(at: CGPoint(x: -pageRect.height + 5.0, y: tabX))
//        }
//        drawContext.restoreGState()
//    }
//
}
