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

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            
            let domainPosition = addText(ofWidth: pageWidth,
                                       entitled: "Domaine d'activité: ",
                                       withText: prepFileData.domainActivity)
            let titlePosition = addText(ofWidth: pageWidth,
                                      entitled: "Titre: ",
                                      withText: prepFileData.title,
                                      under: domainPosition.maxY)
            let sessionNumberPosition = addText(ofWidth: pageWidth / 2,
                                             entitled: "Séance nº: ",
                                             withText: "\(prepFileData.sessionNumber)",
                                             under: titlePosition.maxY)
            let _ = addText(ofWidth: pageWidth,
                            entitled: "Date: ",
                            withText: Util.formatDate(prepFileData.date),
                            under: titlePosition.maxY,
                            next: sessionNumberPosition.maxX)
            let levelPosition = addText(ofWidth: pageWidth / 2,
                                      entitled: "Niveau: ",
                                      withText: prepFileData.level,
                                      under: sessionNumberPosition.maxY)
            let _ = addText(ofWidth: pageWidth,
                            entitled: "Cycle: ",
                            withText: "\(prepFileData.cycle)",
                            under: sessionNumberPosition.maxY,
                            next: levelPosition.maxX)
            let totalDurationPosition = addText(ofWidth: pageWidth,
                                         entitled: "Durée: ",
                                         withText: "\(prepFileData.duration)min",
                                         under: levelPosition.maxY)
            
            
            
            let mainGoalPosition = addText(ofWidth: pageWidth,
                                         entitled: "Objectif général: ",
                                         withText: prepFileData.mainGoal,
                                         under: totalDurationPosition.maxY + 15)
            let specificGoalPosition = addText(ofWidth: pageWidth,
                                             entitled: "Objectif spécifique: ",
                                             withText: prepFileData.specificGoal,
                                             under: mainGoalPosition.maxY)
            let materialPosition = addText(ofWidth: pageWidth,
                                         entitled: "Matériel: ",
                                         withText: prepFileData.material,
                                         under: specificGoalPosition.maxY)

            
            let bottomWidth = pageWidth - 25
            var baseTopPosition = materialPosition.maxY + 10
            var allPositions: [PositionData] = []
            if let phase = prepFileData.phases {
                let numberOfPhase = phase.list.count
                for i in 0..<numberOfPhase {
                    let phasePosition = addText(ofWidth: bottomWidth * 0.075,
                                                entitled: i == 0 ? "Phase\n" : "\n",
                                                withText: phase.list[i].phaseNumber.description,
                                                under: baseTopPosition + 5)
                    let consignePosition = addText(ofWidth: bottomWidth * 0.400,
                                                   entitled: i == 0 ? "Consigne\n" : "\n",
                                                   withText: phase.list[i].consigne ?? "",
                                                   under: baseTopPosition + 5,
                                                   next: phasePosition.maxX + 5)
                    let phaseDurationPosition = addText(ofWidth: bottomWidth * 0.05,
                                                   entitled: i == 0 ? "Durée\n" : "\n",
                                                   withText: "\(phase.list[i].phaseDuration) min",
                                                   under: baseTopPosition + 5,
                                                   next: consignePosition.maxX + 5)
                    let teacherRolePosition = addText(ofWidth: bottomWidth * 0.175,
                                                      entitled: i == 0 ? "Rôle de l'enseignant\n" : "\n",
                                                      withText: phase.list[i].teacherRole ?? "",
                                                      under: baseTopPosition + 5,
                                                      next: phaseDurationPosition.maxX + 5)
                    let pupilRolePosition = addText(ofWidth: bottomWidth * 0.150,
                                                    entitled: i == 0 ? "Rôle de l'élève\n" : "\n",
                                                    withText: phase.list[i].pupilRole ?? "",
                                                    under: baseTopPosition + 5,
                                                    next: teacherRolePosition.maxX + 5)
                    let differenciationPosition = addText(ofWidth: bottomWidth * 0.150,
                                                          entitled: i == 0 ? "Différenciation\n" : "\n",
                                                          withText: phase.list[i].differenciation ?? "",
                                                          under: baseTopPosition + 5,
                                                          next: pupilRolePosition.maxX + 5)
                    baseTopPosition += [phasePosition.height, consignePosition.height, phaseDurationPosition.height, teacherRolePosition.height, pupilRolePosition.height, differenciationPosition.height].sorted().last!
                    if i == numberOfPhase - 1 {
                        allPositions.append(phasePosition)
                        allPositions.append(consignePosition)
                        allPositions.append(phaseDurationPosition)
                        allPositions.append(teacherRolePosition)
                        allPositions.append(pupilRolePosition)
                        allPositions.append(differenciationPosition)
                    }
                }
            }
            
            guard !allPositions.isEmpty else {
                return
            }
            
            // Draw frame
            let topBorder: CGFloat = 10.0
            let leftBorder: CGFloat = 10.0
            let bottomBorder = pageRect.height - 10
            let rightBorder = pageRect.width - 10
            // Top section - Top line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: rightBorder,
                     startY: topBorder,
                     endY: topBorder)
            // Top section - Bottom line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: rightBorder,
                     startY: totalDurationPosition.maxY + 2,
                     endY: totalDurationPosition.maxY + 2)
            // Top section - Left line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: leftBorder,
                     startY: topBorder,
                     endY: totalDurationPosition.maxY + 2)
            // Top section - Right line
            drawLine(context.cgContext,
                     startX: rightBorder,
                     endX: rightBorder,
                     startY: topBorder,
                     endY: totalDurationPosition.maxY + 2)

            // Middle section - Top line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: rightBorder,
                     startY: totalDurationPosition.maxY + 13,
                     endY: totalDurationPosition.maxY + 13)
            // Middle section - Bottom line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: rightBorder,
                     startY: materialPosition.maxY + 2,
                     endY: materialPosition.maxY + 2)
            // Middle section - Left line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: leftBorder,
                     startY: totalDurationPosition.maxY + 13,
                     endY: materialPosition.maxY + 2)
            // Middle section - Right line
            drawLine(context.cgContext,
                     startX: rightBorder,
                     endX: rightBorder,
                     startY: totalDurationPosition.maxY + 13,
                     endY: materialPosition.maxY + 2)

            // Bottom section - Top line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: rightBorder,
                     startY: materialPosition.maxY + 13,
                     endY: materialPosition.maxY + 13)
            // Bottom section - Bottom line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: rightBorder,
                     startY: bottomBorder,
                     endY: bottomBorder)
            // Bottom section - Left line
            drawLine(context.cgContext,
                     startX: leftBorder,
                     endX: leftBorder,
                     startY: materialPosition.maxY + 13,
                     endY: bottomBorder)
            // Bottom section - Right line
            drawLine(context.cgContext,
                     startX: rightBorder,
                     endX: rightBorder,
                     startY: materialPosition.maxY + 13,
                     endY: bottomBorder)
            
            // Bottom section - Intercolumn line
            let topBottomSection = materialPosition.maxY + 13
            for i in 0...4 {
                drawLine(context.cgContext,
                         startX: allPositions[i].maxX + 2,
                         endX: allPositions[i].maxX + 2,
                         startY: topBottomSection,
                         endY: bottomBorder)
            }
        }

        return data
    }
    
    func addText(ofWidth: CGFloat, entitled: String, withText text: String, under bottomPosition: CGFloat = 12, next rightPosition: CGFloat = 12) -> PositionData {

        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        let boldFont = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping

        let entitledAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: boldFont,
             NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let entitledText = NSMutableAttributedString(string: entitled, attributes: entitledAttributes)

        let textAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: textFont,
             NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        
        entitledText.append(attributedText)
        let textStringSize = entitledText.string.size(withAttributes: textAttributes, width: ofWidth)
        let textStringRect = CGRect(x: rightPosition,
                                    y: bottomPosition,
                                    width: ofWidth,
                                    height: textStringSize.height)
        
        entitledText.draw(in: textStringRect)
        return PositionData(maxX: textStringRect.origin.x + textStringRect.size.width, maxY: textStringRect.origin.y + textStringRect.size.height, height: textStringSize.height)
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

struct PositionData {
    let maxX: CGFloat
    let maxY: CGFloat
    let height: CGFloat
}
