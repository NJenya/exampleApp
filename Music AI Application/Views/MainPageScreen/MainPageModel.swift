//
//  MainPageModel.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 01.03.2025.
//

import SwiftUI

final class MainPageModel: ObservableObject {
    @Published var isEditingName: Bool = false
    @Published var isEditingLyrics: Bool = false
//    @Published var songsLeft: Int = UserDefaultsManager.shared.songsLeft
    @Published var songName: String = "Song \(UserDefaultsManager.shared.song_generated_without_name)"
    @Published var selectedStyles: [String] = UserDefaultsManager.shared.selectedStyle
    @Published var navigateToMusicStyles = false
    @Published var navigateToPremiumFromModalAlertView = false
    @Published var navigateToPremiumFromNavBar = false
    @Published var showGeneratingAlert: Bool = false
    @Published var showModalAlertView: Bool = false
    @Published var draftLyrics: String = ""
    @Published var showNoLyricsAlert: Bool = false
    @Published var showLimitIsFinished: Bool = false
    @Published var exceededDailyLimit: Bool = false
    @Published var generateWithNoLyrics: Bool = false
    @AppStorage("savedLyrics") var savedLyrics: String = ""
    @AppStorage("songsLeft") var songsLeft: Int = UserDefaultsManager.shared.songsLeft

    
    func handleGenerateMusic(model: MusicModel) -> Bool {
        let hasSubscription = UserDefaultsManager.shared.hasSubscription
        let currentGenerated = UserDefaultsManager.shared.generated_Music_number_per_day
        let generationLimit = UserDefaultsManager.shared.generations_limit_per_day
        let noLyrics = model.songLyrics.isEmpty

        if hasSubscription {
            if currentGenerated >= generationLimit {
                print("Alert with OOPS")
                exceededDailyLimit = true
                return false
            }
        } else {
            if songsLeft <= 0 {
                print("Show alert that says free generations ended")
                showModalAlertView = true
                return false
            }
        }
//        
//        if noLyrics {
//            print("Show Alert: No Lyrics")
//            showNoLyricsAlert = true
//        }
        
        if noLyrics && !generateWithNoLyrics {
            print("Show Alert: No Lyrics provided and generateWithNoLyrics is false")
            showNoLyricsAlert = true
            return false
        }
        
        if !hasSubscription {
            songsLeft -= 1
        }
        
        if !(noLyrics && generateWithNoLyrics){
            showGeneratingAlert = true
        }
        
        UserDefaultsManager.shared.generated_Music_number_per_day += 1
        
        UserDefaultsManager.shared.song_generated_without_name += 1
        UserDefaultsManager.shared.songsLeft = songsLeft
        songName = "Song \(UserDefaultsManager.shared.song_generated_without_name)"
        generateWithNoLyrics = false
        UserDefaults.standard.synchronize()
        return true
    }
    
    func getName() -> String {
        let number = UserDefaultsManager.shared.song_generated_without_name
        return "Song \(number)"
    }
}
