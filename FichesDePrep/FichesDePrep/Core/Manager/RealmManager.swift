//
//  RealmManager.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 23/09/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    let realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func write(_ completion: ()->Void) {
        do {
            try realm.write() {
                completion()
            }
        } catch {
            print(error)
        }
    }
    
    func add(_ object: Object) {
        realm.add(object)
    }
    
    func delete(_ object: Object) {
        realm.delete(object)
    }
    
    func objects<Element>(_ type: Element.Type) -> Results<Element> where Element : Object {
        return realm.objects(type)
    }
}
