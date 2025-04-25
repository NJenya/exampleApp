//
//  Untitled.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 27.01.2025.
//

import Foundation

struct LibrarySongModel: Identifiable {
    var id: UUID 
    var songTitle: String
    let songImageName: String
    let genre: [String]
    var duration: Double?
    let lyrics: String
    var isLoading: Bool = false
    var audioURL: String?
    var requestID: String?
    
    var genreString: String {
        return genre.joined(separator: ", ")
    }
    
    var durationString: String {
        guard let duration = duration else { return "" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
