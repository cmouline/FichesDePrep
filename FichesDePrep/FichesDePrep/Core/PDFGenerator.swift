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
        
        let pageRect = CGRect(x: 0, y: 0, width: 11.75 * 72.0, height: 8.25 * 72.0)
        let pageWidth = pageRect.width - 24
        let pageHeight = pageRect.height - 24

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let domainBottom = addText(ofWidth: pageWidth, entitled: "Domaine d'activité: ", withText: prepFileData.activityKind)
            let titleBottom = addText(ofWidth: pageWidth, entitled: "Titre: ", withText: prepFileData.title, under: domainBottom.0)
            let seanceNumberBottom = addText(ofWidth: pageWidth / 2, entitled: "Séance nº: ", withText: "\(prepFileData.seanceNumber)", under: titleBottom.0)
            let _ = addText(ofWidth: pageWidth, entitled: "Date: ", withText: "\(prepFileData.date)", under: titleBottom.0, next: seanceNumberBottom.1)
            let levelBottom = addText(ofWidth: pageWidth / 2, entitled: "Niveau: ", withText: prepFileData.level, under: seanceNumberBottom.0)
            let _ = addText(ofWidth: pageWidth, entitled: "Cycle: ", withText: "\(prepFileData.cycle)", under: seanceNumberBottom.0, next: levelBottom.1)
            let durationBottom = addText(ofWidth: pageWidth, entitled: "Durée: ", withText: "\(prepFileData.duration)min", under: levelBottom.0)
            let mainGoalBottom = addText(ofWidth: pageWidth, entitled: "Objectif général: ", withText: prepFileData.mainGoal, under: durationBottom.0 + 15)
            let specificGoalBottom = addText(ofWidth: pageWidth, entitled: "Objectif spécifique: ", withText: prepFileData.specificGoal, under: mainGoalBottom.0)
            let materialBottom = addText(ofWidth: pageWidth, entitled: "Matériel: ", withText: prepFileData.material, under: specificGoalBottom.0)

            let phasePosition = addText(ofWidth: pageWidth * 0.125, andHeight: pageRect.height - materialBottom.0 + 20, entitled: "Phase\n", withText: "", under: materialBottom.0 + 20)
            let consignePosition = addText(ofWidth: pageWidth * 0.350, andHeight: pageRect.height - materialBottom.0 + 20, entitled: "Consigne\n", withText: prepFileData.phases?.list[0].consigne as! String, under: materialBottom.0 + 20, next: phasePosition.1 + 5)
            let durationPosition = addText(ofWidth: pageWidth * 0.05, andHeight: pageRect.height - materialBottom.0 + 20, entitled: "Durée\n", withText: "\(prepFileData.phases?.list[0].phaseDuration) min", under: materialBottom.0 + 20, next: consignePosition.1 + 5)
            let teacherRolePosition = addText(ofWidth: pageWidth * 0.175, andHeight: pageRect.height - materialBottom.0 + 20, entitled: "Rôle de l'enseignant\n", withText: prepFileData.phases?.list[0].teacherRole ?? "", under: materialBottom.0 + 20, next: durationPosition.1 + 5)
            let pupilRolePosition = addText(ofWidth: pageWidth * 0.150, andHeight: pageRect.height - materialBottom.0 + 20, entitled: "Rôle de l'élève\n", withText: prepFileData.phases?.list[0].pupilRole ?? "", under: materialBottom.0 + 20, next: teacherRolePosition.1 + 5)
            let _ = addText(ofWidth: pageWidth * 0.150, andHeight: pageRect.height - materialBottom.0 + 20, entitled: "Différenciation\n", withText: prepFileData.phases?.list[0].differenciation ?? "", under: materialBottom.0 + 20, next: pupilRolePosition.1)
        }
        
        return data
    }
    
    func addText(ofWidth: CGFloat, andHeight: CGFloat? = nil, entitled: String, withText text: String, under bottomPosition: CGFloat = 12, next rightPosition: CGFloat = 12) -> (CGFloat, CGFloat) {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        let boldFont = UIFont.systemFont(ofSize: 12.0, weight: .bold)

        let entitledAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: boldFont]
        let entitledText = NSMutableAttributedString(string: entitled, attributes: entitledAttributes)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineBreakMode = .byWordWrapping
        let textAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: textFont,
             NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        
        entitledText.append(attributedText)
        let textStringSize = entitledText.size()
        let textStringRect = CGRect(x: rightPosition,
                                    y: bottomPosition,
                                    width: ofWidth,
                                    height: andHeight == nil ? textStringSize.height : andHeight!)
        
        entitledText.draw(in: textStringRect)
        return (textStringRect.origin.y + textStringRect.size.height, textStringRect.origin.x + textStringRect.size.width)
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
