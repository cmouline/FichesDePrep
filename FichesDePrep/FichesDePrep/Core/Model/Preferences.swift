//
//  Preferences.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 18/10/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import Foundation
import RealmSwift

class Preferences: Object {
    
    @objc dynamic var level: String?
    @objc dynamic var cycle: Int = 0
}
