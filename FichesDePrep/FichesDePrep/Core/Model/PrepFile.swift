//
//  PrepFile.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 22/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import Foundation
import RealmSwift

class PrepFile: Object {
    
    @objc dynamic var creationDate: Date = Date()
    @objc dynamic var lastModificationDate: Date = Date()
    @objc dynamic var title: String = "Pas de titre"
    
    @objc dynamic var activityKind: String = ""
    @objc dynamic var seanceNumber: Int = 0
    @objc dynamic var level: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var date: Date = Date()
    @objc dynamic var cycle: Int = 0
    
    @objc dynamic var mainGoal: String = ""
    @objc dynamic var specificGoal: String = ""
    @objc dynamic var material: String = ""
    
    @objc dynamic var phase: String = ""
    @objc dynamic var consigne: String = ""
    @objc dynamic var phaseDuration: String = ""
    @objc dynamic var teacherRole: String = ""
    @objc dynamic var pupilRole: String = ""
    @objc dynamic var differenciation: String = ""
    
    dynamic var isDraft: Bool = true
    
    init(title: String? = nil, activityKind: String? = nil, seanceNumber: Int? = nil, level: String? = nil, duration: Int? = nil, date: Date? = nil, cycle: Int? = nil, mainGoal: String? = nil, specificGoal: String? = nil, material: String? = nil, phase: String? = nil, consigne: String? = nil, phaseDuration: String? = nil, teacherRole: String? = nil, pupilRole: String? = nil, differenciation: String? = nil, isDraft: Bool = true) {
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
        self.isDraft = isDraft
        super.init()
    }
    
    required init() {
    }
}
