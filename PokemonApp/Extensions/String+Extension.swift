//
//  String+Extension.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns a substring of the original string.
    /// - Parameters:
    ///   - nsrange
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
    
    /// Replaces \n with whitespaces
    var replaceNewlinesWithWhitespaces: String {
        return components(separatedBy: .newlines).joined(separator: " ")
    }
    
    /// Localized version of the string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
