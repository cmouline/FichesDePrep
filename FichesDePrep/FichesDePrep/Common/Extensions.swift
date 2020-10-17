//
//  Extensions.swift
//  FichesDePrep
//
//  Created by Chloe Moulinet on 17/10/2020.
//  Copyright © 2020 Chloe Moulinet. All rights reserved.
//

import UIKit

extension String {
    func size(withAttributes attributes: [NSAttributedString.Key: Any], width: CGFloat) -> CGSize {
    let attrString = NSAttributedString(string: self, attributes: attributes)
        let bounds = attrString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: bounds.width, height: bounds.height)
        return size
    }
}
