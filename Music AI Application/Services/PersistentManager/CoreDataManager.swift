//
//  CoreDataManager.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 07.03.2025.
//

import Foundation
import CoreData

final class CoreDataManager: ObservableObject {
    let container = NSPersistentContainer(name: "CoreData")
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSongs() -> [MusicItem] {
        let request: NSFetchRequest<MusicItem> = MusicItem.fetch()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch songs: \(error.localizedDescription)")
            return []
        }
    }
    
    func addSong(model: LibrarySongModel) {
        container.performBackgroundTask { backgroundContext in
            let newSong = MusicItem(context: backgroundContext)
            newSong.id = model.id
            newSong.title = model.songTitle
            newSong.timeStamp_ = Date()
            newSong.audio_duration = model.duration ?? 0.0
            newSong.audio_url = model.audioURL
            newSong.image_url = model.songImageName
            newSong.decodedGenres = model.genre
            newSong.lyrics = model.lyrics
            newSong.isLoading = model.isLoading
            newSong.requestID = model.requestID
            
            do {
                try backgroundContext.save()
                print("✅ Song saved successfully: \(newSong.title ?? "Unknown")")
            } catch {
                print("❌ Failed to save song: \(error.localizedDescription)")
            }
        }
        
        let songs = CoreDataManager.shared.fetchSongs()
        print("Songs count: \(songs.count)")
    }
    
    
    func renameSong(by id: UUID, newTitle: String) {
        container.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest<MusicItem> = MusicItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let song = try backgroundContext.fetch(request).first {
                    song.title = newTitle
                    try backgroundContext.save()
                    print("✅ Song renamed successfully to: \(newTitle)")
                } else {
                    print("⚠️ No song found with ID: \(id)")
                }
            } catch {
                print("❌ Failed to rename song: \(error)")
            }
        }
    }
    
    func deleteSong(by id: UUID) {
        container.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest<MusicItem> = MusicItem.fetch()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let songToDelete = try backgroundContext.fetch(request).first {
                    backgroundContext.delete(songToDelete)
                    try backgroundContext.save()
                    print("✅ Song deleted successfully")
                } else {
                    print("⚠️ No song found with ID: \(id)")
                }
            } catch {
                print("❌ Failed to delete song: \(error)")
            }
        }
    }
    
    func resetCoreData() {
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreData.sqlite")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: storeURL)
            print("Core Data reset successfully!")
        } catch {
            print("Failed to reset Core Data: \(error)")
        }
    }
    
    func updateSong(by id: UUID, newDuration: Double, newAudioURL: String) {
        container.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest<MusicItem> = MusicItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let song = try backgroundContext.fetch(request).first {
                    song.audio_duration = newDuration
                    song.audio_url = newAudioURL
                    song.isLoading = false
                    try backgroundContext.save()
                    print("✅ Song updated successfully for id: \(id)")
                } else {
                    print("⚠️ No song found with ID: \(id)")
                }
            } catch {
                print("❌ Failed to update song: \(error.localizedDescription)")
            }
        }
    }
    
}

