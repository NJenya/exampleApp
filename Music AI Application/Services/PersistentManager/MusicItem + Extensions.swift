//
//  MusicItem + Extensions.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 08.03.2025.
//

import Foundation
import CoreData

extension MusicItem {
    
//    var timeStamp: Date {
//        get { timeStamp_ ?? Date()}
//        set { timeStamp_ = newValue }
//    }
    
    static func fetch() -> NSFetchRequest<MusicItem> {
        let request = NSFetchRequest<MusicItem>(entityName: "MusicItem")
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp_", ascending: false)]
        return request
    }

    
    var decodedGenres: [String] {
        get {
            guard let data = self.music_styles else { return [] }
            if let genres = try? JSONDecoder().decode([String].self, from: data) {
                return genres
            }
            return []
        }
        set {
            self.music_styles = try? JSONEncoder().encode(newValue)
        }
    }
}
