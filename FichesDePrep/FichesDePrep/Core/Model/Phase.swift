//
//  Phase.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 13/10/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import Foundation
import RealmSwift

class PhaseList: Object {
    dynamic var list: List<Phase> = List<Phase>()

    convenience init(list: [Phase] = []) {
        self.init()
        for item in list {
            self.list.append(item)
        }
    }
    
    required init() {
//        fatalError("init() has not been implemented")
    }
}

class Phase: Object {
    
    @objc dynamic var phaseNumber: Int = 0
    @objc dynamic var consigne: String? = ""
    @objc dynamic var phaseDuration: Int = 0
    @objc dynamic var teacherRole: String? = ""
    @objc dynamic var pupilRole: String? = ""
    @objc dynamic var differenciation: String? = ""

    convenience init(phaseNumber: Int?, consigne: String?, phaseDuration: Int?, teacherRole: String?, pupilRole: String?, differenciation: String?) {
        self.init()
        self.phaseNumber = phaseNumber ?? 0
        self.consigne = consigne
        self.phaseDuration = phaseDuration ?? 0
        self.teacherRole = teacherRole
        self.pupilRole = pupilRole
        self.differenciation = differenciation
    }
    
    required init() {
//        fatalError("init() has not been implemented")
    }
}
