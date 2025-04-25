//
//  MusicModel.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 05.03.2025.
//

import Foundation

struct MusicModel: Identifiable, Equatable {
    let songName: String
    let selectedStyles: [String]
    let songLyrics: String
    let songID: UUID
    
    var id: UUID {
        return songID
    }
    
    static func == (lhs: MusicModel, rhs: MusicModel) -> Bool {
        return lhs.songID == rhs.songID
    }
}
