//
//  UserDefaultsManager.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 27.01.2025.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    var selectedStyle: [String] {
        get {
            let storedArray = UserDefaults.standard.array(forKey: UserDefaultsKeys.selectedStyle.rawValue) as? [String] ?? ["Pop"]
            return storedArray.isEmpty ? ["Pop"] : storedArray
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.selectedStyle.rawValue)
        }
    }
    
    var songsLeft: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.songsLeft.rawValue)}
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.songsLeft.rawValue)
        }
    }
    
    var hasSubscription: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSubscription.rawValue)}
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.hasSubscription.rawValue)
        }
    }
    
    var isConfigured: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isConfigured.rawValue)}
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isConfigured.rawValue)
        }
    }
    
    var isWelcomeTourCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isWelcomeTourCompleted.rawValue)}
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isWelcomeTourCompleted.rawValue)
        }
    }
    
    var rateUsIsShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.rateUsIsShown.rawValue)}
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.rateUsIsShown.rawValue)
        }
    }
    
    var reviewPaywallIsShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.reviewPaywallIsShown.rawValue)}
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.reviewPaywallIsShown.rawValue)
        }
    }
    
    var onboarding_first_subscription: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.onboarding_first_subscription.rawValue) ?? "com.musicai.1we"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.onboarding_first_subscription.rawValue)
        }
    }
    
    var onboarding_second_subscription: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.onboarding_second_subscription.rawValue) ?? "com.musicai.1ye"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.onboarding_second_subscription.rawValue)
        }
    }
    
    var settings_first_subscription: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.settings_first_subscription.rawValue) ?? "com.musicai.1mo"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.settings_first_subscription.rawValue)
        }
    }
    
    var settings_second_subscription: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.settings_second_subscription.rawValue) ?? "com.musicai.1ye"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.settings_second_subscription.rawValue)
        }
    }
    
    var free_start_generations: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.free_start_generations.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.free_start_generations.rawValue)
        }
    }
    
    var generations_limit_per_day: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.generations_limit_per_day.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.generations_limit_per_day.rawValue)
        }
    }
    
    var generated_Music_number_per_day: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.generated_Music_number_per_day.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.generated_Music_number_per_day.rawValue)
        }
    }
    
    var song_generated_without_name: Int {
        get {
            if let value = UserDefaults.standard.object(forKey: UserDefaultsKeys.song_generated_without_name.rawValue) as? Int {
                return value
            } else {
                return 1
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.song_generated_without_name.rawValue)
        }
    }
        
    var music_service: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.music_service.rawValue) ?? "SunoAI"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.music_service.rawValue)
        }
    }
}

enum UserDefaultsKeys: String {
    case selectedStyle = "selectedStyle"
    case songsLeft = "songsLeft"
    case isConfigured = "isConfigured"
    case isWelcomeTourCompleted = "isWelcomeTourCompleted"
    case rateUsIsShown = "rateUsIsShown"
    case reviewPaywallIsShown = "reviewPaywallIsShown"
    case onboarding_first_subscription = "onboarding_first_subscription"
    case onboarding_second_subscription = "onboarding_second_subscription"
    case settings_first_subscription = "settings_first_subscription"
    case settings_second_subscription = "settings_second_subscription"
    case generations_limit_per_day = "generations_limit_per_day"
    case free_start_generations = "free_start_generations"
    case hasSubscription = "hasSubscription"
    case generated_Music_number_per_day = "generated_Music_number_per_day"
    case song_generated_without_name = "song_generated_without_name"
    case music_service = "music_service"
}
