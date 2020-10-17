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
        let margin: CGFloat = 12.0
        let pageWidth = pageRect.width - (margin * 2)
        let pageHeight = pageRect.height - (margin * 2)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let domainPosition = addText(ofWidth: pageWidth,
                                       entitled: "Domaine d'activité: ",
                                       withText: prepFileData.activityKind)
            let titlePosition = addText(ofWidth: pageWidth,
                                      entitled: "Titre: ",
                                      withText: prepFileData.title,
                                      under: domainPosition.0)
            let sessionNumberPosition = addText(ofWidth: pageWidth / 2,
                                             entitled: "Séance nº: ",
                                             withText: "\(prepFileData.seanceNumber)",
                                             under: titlePosition.0)
            let _ = addText(ofWidth: pageWidth,
                            entitled: "Date: ",
                            withText: "\(prepFileData.date)",
                            under: titlePosition.0,
                            next: sessionNumberPosition.1)
            let levelPosition = addText(ofWidth: pageWidth / 2,
                                      entitled: "Niveau: ",
                                      withText: prepFileData.level,
                                      under: sessionNumberPosition.0)
            let _ = addText(ofWidth: pageWidth,
                            entitled: "Cycle: ",
                            withText: "\(prepFileData.cycle)",
                            under: sessionNumberPosition.0,
                            next: levelPosition.1)
            let totalDurationPosition = addText(ofWidth: pageWidth,
                                         entitled: "Durée: ",
                                         withText: "\(prepFileData.duration)min",
                                         under: levelPosition.0)
            
            
            
            let mainGoalPosition = addText(ofWidth: pageWidth,
                                         entitled: "Objectif général: ",
                                         withText: prepFileData.mainGoal,
                                         under: totalDurationPosition.0 + 15)
            let specificGoalPosition = addText(ofWidth: pageWidth,
                                             entitled: "Objectif spécifique: ",
                                             withText: prepFileData.specificGoal,
                                             under: mainGoalPosition.0)
            let materialPosition = addText(ofWidth: pageWidth,
                                         entitled: "Matériel: ",
                                         withText: prepFileData.material,
                                         under: specificGoalPosition.0)

            
            let bottomWidth = pageWidth - 25
            let phasePosition = addText(ofWidth: bottomWidth * 0.075,
                                        andHeight: pageHeight - materialPosition.0,
                                        entitled: "Phase\n",
                                        withText: prepFileData.phases?.list[0].phaseNumber.description ?? "",
                                        under: materialPosition.0 + 15)
            let consignePosition = addText(ofWidth: bottomWidth * 0.400,
                                           andHeight: pageHeight - materialPosition.0,
                                           entitled: "Consigne\n",
                                           withText: prepFileData.phases?.list[0].consigne ?? "",
                                           under: materialPosition.0 + 15,
                                           next: phasePosition.1 + 5)
            let phaseDurationPosition = addText(ofWidth: bottomWidth * 0.05,
                                           andHeight: pageHeight - materialPosition.0,
                                           entitled: "Durée\n",
                                           withText: "\(prepFileData.phases?.list[0].phaseDuration) min",
                                           under: materialPosition.0 + 15,
                                           next: consignePosition.1 + 5)
            let teacherRolePosition = addText(ofWidth: bottomWidth * 0.175,
                                              andHeight: pageHeight - materialPosition.0,
                                              entitled: "Rôle de l'enseignant\n",
                                              withText: prepFileData.phases?.list[0].teacherRole ?? "",
                                              under: materialPosition.0 + 15,
                                              next: phaseDurationPosition.1 + 5)
            let pupilRolePosition = addText(ofWidth: bottomWidth * 0.150,
                                            andHeight: pageHeight - materialPosition.0,
                                            entitled: "Rôle de l'élève\n",
                                            withText: prepFileData.phases?.list[0].pupilRole ?? "",
                                            under: materialPosition.0 + 15,
                                            next: teacherRolePosition.1 + 5)
            let _ = addText(ofWidth: bottomWidth * 0.150,
                            andHeight: pageHeight - materialPosition.0,
                            entitled: "Différenciation\n",
                            withText: prepFileData.phases?.list[0].differenciation ?? "",
                            under: materialPosition.0 + 15,
                            next: pupilRolePosition.1 + 5)
            
            
            // Draw frame
            // Top section - Top line
            drawLine(context.cgContext, startX: 10, endX: pageRect.width - 10, startY: 10, endY: 10)
            // Top section - Bottom line
            drawLine(context.cgContext, startX: 10, endX: pageRect.width - 10, startY: totalDurationPosition.0 + 2, endY: totalDurationPosition.0 + 2)
            // Top section - Left line
            drawLine(context.cgContext, startX: 10, endX: 10, startY: 10, endY: totalDurationPosition.0 + 2)
            // Top section - Right ine
            drawLine(context.cgContext, startX: pageRect.width - 10, endX: pageRect.width - 10, startY: 10, endY: totalDurationPosition.0 + 2)

            // Middle section - Top line
            drawLine(context.cgContext, startX: 10, endX: pageRect.width - 10, startY: totalDurationPosition.0 + 13, endY: totalDurationPosition.0 + 13)
            // Middle section - Bottom line
            drawLine(context.cgContext, startX: 10, endX: pageRect.width - 10, startY: materialPosition.0 + 2, endY: materialPosition.0 + 2)
            // Middle section - Left line
            drawLine(context.cgContext, startX: 10, endX: 10, startY: totalDurationPosition.0 + 13, endY: materialPosition.0 + 2)
            // Middle section - Right ine
            drawLine(context.cgContext, startX: pageRect.width - 10, endX: pageRect.width - 10, startY: totalDurationPosition.0 + 13, endY: materialPosition.0 + 2)

            // Bottom section - Top line
            drawLine(context.cgContext, startX: 10, endX: pageRect.width - 10, startY: materialPosition.0 + 13, endY: materialPosition.0 + 13)
            // Bottom section - Bottom line
            drawLine(context.cgContext, startX: 10, endX: pageRect.width - 10, startY: phasePosition.0 + 2, endY: phasePosition.0 + 2)
            // Bottom section - Left line
            drawLine(context.cgContext, startX: 10, endX: 10, startY: materialPosition.0 + 13, endY: phasePosition.0 + 2)
            // Bottom section - Right ine
            drawLine(context.cgContext, startX: pageRect.width - 10, endX: pageRect.width - 10, startY: materialPosition.0 + 13, endY: phasePosition.0 + 2)
            
            // Bottom section - Phase / Consigne
            drawLine(context.cgContext, startX: phasePosition.1 + 2, endX: phasePosition.1 + 2, startY: materialPosition.0 + 13, endY: phasePosition.0 + 2)
            // Bottom section - Phase / Consigne
            drawLine(context.cgContext, startX: consignePosition.1 + 2, endX: consignePosition.1 + 2, startY: materialPosition.0 + 13, endY: consignePosition.0 + 2)
            // Bottom section - Phase / Consigne
            drawLine(context.cgContext, startX: phaseDurationPosition.1 + 2, endX: phaseDurationPosition.1 + 2, startY: materialPosition.0 + 13, endY: phaseDurationPosition.0 + 2)
            // Bottom section - Phase / Consigne
            drawLine(context.cgContext, startX: teacherRolePosition.1 + 2, endX: teacherRolePosition.1 + 2, startY: materialPosition.0 + 13, endY: teacherRolePosition.0 + 2)
            // Bottom section - Phase / Consigne
            drawLine(context.cgContext, startX: pupilRolePosition.1 + 2, endX: pupilRolePosition.1 + 2, startY: materialPosition.0 + 13, endY: pupilRolePosition.0 + 2)
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
        paragraphStyle.alignment = .left
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
    
    func drawLine(_ drawContext: CGContext, startX: CGFloat, endX: CGFloat, startY: CGFloat, endY: CGFloat) {
        
        drawContext.saveGState()
        drawContext.setLineWidth(1.0)

        drawContext.move(to: CGPoint(x: startX, y: startY))
        drawContext.addLine(to: CGPoint(x: endX, y: endY))
        drawContext.strokePath()
        drawContext.restoreGState()
        
        drawContext.saveGState()
    }
}
