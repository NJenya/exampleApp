//
//  LibraryViewModel.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 02.03.2025.
//

import Foundation
import Combine
import CoreData

final class LibraryViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    //    @Published var songsLeft: Int = UserDefaultsManager.shared.songsLeft
    @Published var showModalAlertView: Bool = false
    @Published var navigateToPremiumFromNavBar = false
    @Published var navigateToPremiumFromModalAlertView = false
    @Published var navigateToMusicPage = false
    @Published var songViewModels: [LibrarySongModel] = []
    @Published var selectedSongIndex: Int = 0
    @Published var selectedSong: LibrarySongModel?
    
    @Published var progress: Double = 0.0
    @Published var isGenerating: Bool = true
    
    @Published var showRenameAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var showShareAlert: Bool = false
    @Published var showDownloadAlert: Bool = false
    @Published var selectedOption: SettingsOption?
    private var cancellables = Set<AnyCancellable>()
    
    private var timer: Timer?
    private let coreDataManager = CoreDataManager.shared
    private var networkingService: NetworkingProtocol
    
    init(context: NSManagedObjectContext, sharedViewModel: SharedViewModel, apiType: APIType) {
        self.networkingService = MusicServiceFactory.createMusicService(using: apiType)
        self.context = context
        fetchSongs()
        sharedViewModel.songAddedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newSong in
                self?.addSongToLibrary(newSong ?? nil)
            }
            .store(in: &cancellables)
    }
    
    func addSongToLibrary(_ song: MusicModel?) {
        guard let song else {
            return
        }
        
        let newSongViewModel = LibrarySongModel(
            id: song.songID,
            songTitle: song.songName,
            songImageName: song.selectedStyles.first?.camelCased() ?? "pop",
            genre: song.selectedStyles,
            duration: nil,
            lyrics: song.songLyrics,
            isLoading: true,
            audioURL: nil,
            requestID: nil
        )
        
        guard !self.songViewModels.contains(where: { $0.id == newSongViewModel.id }) else {
            return
        }
        
        DispatchQueue.main.async{
            self.songViewModels.insert(newSongViewModel, at: 0)
        }
        Task {
            if let requestID = await self.sendRequestToAPI(model: song) {
                await MainActor.run {
                    if let index = self.songViewModels.firstIndex(where: { $0.id == song.id }) {
                        setIDForFetchedModel(with: requestID, for: newSongViewModel, index: index)
                        self.saveSong(song: songViewModels[index])
                    } else {
                        print("[DEBUG] Could not find songViewModel for song id: \(song.id) after API call.")
                    }
                }
                
                if let fetchedSongData = await getSongDataFromAPI(with: requestID) {
                    await MainActor.run {
                        if let index = self.songViewModels.firstIndex(where: { $0.requestID == requestID }) {
                            self.setupMusicData(for: index, with: fetchedSongData)
                        } else {
                            print("[DEBUG] No matching cell found for requestID: \(requestID)")
                        }
                    }
                } else {
                    print("[DEBUG] Failed to fetch song data from API for requestID: \(requestID)")
                }
            } else {
                print("[DEBUG] sendRequestToAPI returned nil. Removing songViewModel with id: \(newSongViewModel.id)")
                self.songViewModels.removeAll { model in
                    model.id == newSongViewModel.id
                }
            }
        }
    }

    func cancelGeneration() {
        let loadingSongs = songViewModels.filter { $0.isLoading }
        for song in loadingSongs {
            coreDataManager.deleteSong(by: song.id)
        }
        songViewModels = songViewModels.filter { !$0.isLoading }
    }

    func toggleMenuAlert(_ option: SettingsOption?) {
        if let option = option {
            switch option {
            case .rename:
                showRenameAlert = true
            case .delete:
                showDeleteAlert = true
            case .share:
                showShareAlert = true
            case .download:
                showDownloadAlert = true
            }
        }
        selectedOption = nil
    }
    
    func setIDForFetchedModel(with id: String, for fetchedSongModel: LibrarySongModel, index: Int) {
        songViewModels[index] = LibrarySongModel(
            id: fetchedSongModel.id,
            songTitle: fetchedSongModel.songTitle,
            songImageName: fetchedSongModel.genre.first?.camelCased() ?? "pop",
            genre: fetchedSongModel.genre,
            duration: fetchedSongModel.duration,
            lyrics: fetchedSongModel.lyrics,
            isLoading: fetchedSongModel.isLoading,
            audioURL: fetchedSongModel.audioURL,
            requestID: id
        )
    }
    
    func setupMusicData(for index: Int, with data: GeneratedSong) {
        guard index < self.songViewModels.count else {
            print("Index \(index) is out of range. Cannot update music data.")
            return
        }
        var model = self.songViewModels[index]
        model.duration = data.duration
        model.audioURL = data.songPath
        model.isLoading = false
        self.songViewModels[index] = model
        updateSongInCoreData(
            by: model.id,
            generatedSong: data
        )
    }
}

extension LibraryViewModel {
    private func sendRequestToAPI(model: MusicModel) async -> String? {
        print("Fetching..... from api")
        
                do {
                    let nanosecondsPerSecond: UInt64 = 1_000_000_000
                    let delay = 1 * nanosecondsPerSecond
                    try await Task.sleep(nanoseconds: delay)
                } catch {
                    print("Error during sleep: \(error.localizedDescription)")
                    return nil
                }
        let randomRequestID = UUID().uuidString
        return randomRequestID
//        do {
//            return try await networkingService.sendRequest(for: model)
//        } catch {
//            print("Error fetching songID from API: \(error.localizedDescription)")
//            return nil
//        }
    }
    
    private func getSongDataFromAPI(with id: String) async -> GeneratedSong? {
//        do {
//            return try await networkingService.getMusicData(with: id)
//        } catch {
//            print("Error fetching song from API: \(error.localizedDescription)")
//            return nil
//        }
        do {
            let nanosecondsPerSecond: UInt64 = 1_000_000_000
            let delay = 7 * nanosecondsPerSecond
            try await Task.sleep(nanoseconds: delay)
        } catch {
            print("Error during sleep: \(error.localizedDescription)")
            return nil
        }
        
        let randomDuration = Double.random(in: 180...300)

        let randomAudioURL = "https://example.com/audio/\(UUID().uuidString)"
        
        let simulatedGeneratedSong = GeneratedSong(
            imagePath: "",
            songPath: "https://cdn1.suno.ai/a7cc52b6-b606-4cf1-8c2c-e30dbd8a0521.mp3",
            duration: 220.72
        )
        return simulatedGeneratedSong
    }
}

extension LibraryViewModel {
    func shareSong() {}
    
    func downloadSong() {}
}

extension LibraryViewModel {
    func fetchSongs() {
        let storedSongs = fetchSongsFromCoreData()
        self.songViewModels = storedSongs.map {
            LibrarySongModel(
                id: $0.id ?? UUID(),
                songTitle: $0.title ?? "UnKnown",
                songImageName: $0.image_url ?? $0.decodedGenres.first?.camelCased() ?? "rap",
                genre: $0.decodedGenres,
                duration: $0.audio_duration,
                lyrics: $0.lyrics ?? "",
                isLoading: $0.isLoading,
                audioURL: $0.audio_url ?? nil,
                requestID: $0.requestID
            )
        }
        
        self.songViewModels.sort { $0.isLoading && !$1.isLoading }

        retryFetchingPendingSongs()
    }
    
    func retryFetchingPendingSongs() {
        let pendingSongs = songViewModels.filter { $0.isLoading }
        for song in pendingSongs {
            
            guard let requestID = song.requestID else {
                continue
            }
            
            Task {
                if let fetchedSongData = await getSongDataFromAPI(with: requestID) {
                    await MainActor.run {
                        if let index = self.songViewModels.firstIndex(where: { $0.requestID == requestID }) {
                            self.setupMusicData(for: index, with: fetchedSongData)
                        } else {
                            print("No matching cell found for requestID: \(requestID)")
                        }
                    }
                } else {
                    print("Failed to fetch song data for requestID: \(requestID)")
                }
            }
        }
    }
    
    func fetchSongsFromCoreData() -> [MusicItem] {
        return coreDataManager.fetchSongs()
    }
    
    func saveSong(song: LibrarySongModel) {
        coreDataManager.addSong(model: song)
    }
    
    func updateSongInCoreData(by id: UUID, generatedSong: GeneratedSong) {
        coreDataManager.updateSong(
            by: id,
            newDuration: generatedSong.duration,
            newAudioURL: generatedSong.songPath
        )
    }
    
    func renameSong(model: LibrarySongModel?, newName: String) {
        guard let model else {return}
        if let index = songViewModels.firstIndex(where: { $0.id == model.id}){
            songViewModels[index].songTitle = newName
            coreDataManager.renameSong(by: model.id, newTitle: newName)
        }
    }
    
    func deleteSong(model: LibrarySongModel?) {
        guard let model else {return}
        songViewModels.removeAll(where: {$0.id == model.id})
        coreDataManager.deleteSong(by: model.id)
    }
}
