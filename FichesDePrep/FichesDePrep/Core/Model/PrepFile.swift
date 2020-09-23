//
//  PrepFile.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import Foundation

class PrepFile {
    
    var creationDate: Date = Date()
    var lastModificationDate: Date = Date()
    var title: String = "Pas de titre"
    
    var activityKind: String = ""
    var seanceNumber: Int = 0
    var level: String = ""
    var duration: Int = 0
    var date: Date = Date()
    var cycle: Int = 0
    
    var mainGoal: String = ""
    var specificGoal: String = ""
    var material: String = ""
    
    var phase: String = ""
    var consigne: String = ""
    var phaseDuration: String = ""
    var teacherRole: String = ""
    var pupilRole: String = ""
    var differenciation: String = ""
    
    var isDraft: Bool = true
    
    init(title: String? = nil, activityKind: String? = nil, seanceNumber: Int? = nil, level: String? = nil, duration: Int? = nil, date: Date? = nil, cycle: Int? = nil, mainGoal: String? = nil, specificGoal: String? = nil, material: String? = nil, phase: String? = nil, consigne: String? = nil, phaseDuration: String? = nil, teacherRole: String? = nil, pupilRole: String? = nil, differenciation: String? = nil) {
        if let tt = title {
            self.title = tt
        }
        if let ak = activityKind {
            self.activityKind = ak
        }
        if let sn = seanceNumber {
            self.seanceNumber = sn
        }
        if let lv = level {
            self.level = lv
        }
        if let dt = duration {
            self.duration = dt
        }
        if let dt = date {
            self.date = dt
        }
        if let cl = cycle {
            self.cycle = cl
        }
        if let mg = mainGoal {
            self.mainGoal = mg
        }
        if let sg = specificGoal {
            self.specificGoal = sg
        }
        if let mt = material {
            self.material = mt
        }
        if let ph = phase {
            self.phase = ph
        }
        if let cs = consigne {
            self.consigne = cs
        }
        if let pd = phaseDuration {
            self.phaseDuration = pd
        }
        if let tr = teacherRole {
            self.teacherRole = tr
        }
        if let pr = pupilRole {
            self.pupilRole = pr
        }
        if let df = differenciation {
            self.differenciation = df
        }
    }
}
