//
//  Util.swift
//  FichesDePrep
//
//  Created by Moulinet Chloë on 18/10/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import Foundation

class Util {
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
