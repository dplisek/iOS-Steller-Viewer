//
//  String+Localizable.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import Foundation

extension String {
    var localized: String {
        let result = NSLocalizedString(self, comment: self)
        if result == self {
            assertionFailure("Warning: Missing localization for \"\(self)\".")
        }
        return result
    }
}
