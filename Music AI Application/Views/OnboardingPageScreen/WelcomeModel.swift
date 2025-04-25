//
//  WelcomeModel.swift
//  Music AI Application
//
//  Created by Мерей Булатова on 16.01.2025.
//

import SwiftUI

final class WelcomeModel: ObservableObject {
    @Published var currentPage = 0
    
    private let hints = ["Create your own \n", "Discover a Variety", "Turn Any Text"]
    private let subHints = ["song", "of Music Styles", "into Music"]
    private let images = ["onboarding1", "onboarding2", "onboarding3"]

    func increasePage() -> Bool {
        guard currentPage < hints.count - 1 else { return false }
        currentPage += 1
        return true
    }
    
    func getHintAndImage() -> (String, String, String) {
        return (hints[currentPage], subHints[currentPage], images[currentPage])
    }
}
