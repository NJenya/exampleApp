//
//  Extensions.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 24.01.2025.
//

import SwiftUI

extension String {
    func camelCased() -> String {
        let components = self.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "-", with: " ") 
            .components(separatedBy: .whitespacesAndNewlines)
        
        let camelCased = components.enumerated().map { index, word in
            return index == 0 ? word.lowercased() : word.capitalized
        }.joined()
        
        return camelCased
    }
}

extension Font {
    static func dmSans(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .bold:
            fontName = "DMSans-Bold"
        case .semibold:
            fontName = "DMSans-Semibold"
        case .medium:
            fontName = "DMSans-Medium"
        default:
            fontName = "DMSans-Regular"
        }
        return .custom(fontName, size: size)
    }
}
