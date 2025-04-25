//
//  MusicGenerationRequest.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 03.03.2025.
//

import Foundation

struct MusicGenerationRequest: Codable {
    let lyrics: String
    let styles: [String]
}
