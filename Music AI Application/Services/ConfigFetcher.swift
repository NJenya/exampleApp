//
//  ConfigFetcher.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 13.02.2025.
//

import Foundation
import Firebase

final class ConfigManager {
    private let defaultValues: [String: Any] =
    [   "free_start_generations" : 2,
        "generations_limit_per_day" : 100,
        "onboarding_first_subscription" : "com.musicai.1we",
        "onboarding_second_subscription" : "com.musicai.1ye",
        "rateUsIsShown" : false,
        "reviewPaywallIsShown" : false,
        "settings_first_subscription" : "com.musicai.1mo",
        "settings_second_subscription" : "com.musicai.1ye",
        "music_service": "SunoAI"
    ]
    
    func fetchRemoteConfig() async throws {
        let remoteConfig = RemoteConfig.remoteConfig()
        let fetchDuration: TimeInterval = 5
        
        return try await withCheckedThrowingContinuation { continuation in
            remoteConfig.fetch(withExpirationDuration: fetchDuration) { [weak self] status, error in
                guard let self else { return }
                if status == .success {
                    remoteConfig.activate { changed, error in
                        if let error = error {
                            print("Error activating remote config values: \(error.localizedDescription)")
                            continuation.resume(throwing: error)
                            return
                        }
                        self.saveAllRemoteConfigValues(remoteConfig)
                        continuation.resume()
                    }
                } else {
                    if !UserDefaultsManager.shared.isWelcomeTourCompleted {
                        self.applyDefaultValues()
                    }
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: NSError(domain: "FetchFailed", code: -1, userInfo: nil))
                    }
                }
            }
        }
    }
    
    func fetchMusicServiceConfig() async throws {
        let remoteConfig = RemoteConfig.remoteConfig()
        let fetchDuration: TimeInterval = 5
        
        return try await withCheckedThrowingContinuation { continuation in
            remoteConfig.fetch(withExpirationDuration: fetchDuration) { [weak self] status, error in
                guard let self else { return }
                if status == .success {
                    remoteConfig.activate { changed, error in
                        if let error = error {
                            print("Error activating remote config values: \(error.localizedDescription)")
                            continuation.resume(throwing: error)
                            return
                        }
                        self.saveMusicServiceConfig(remoteConfig)
                        continuation.resume()
                    }
                } else {
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: NSError(domain: "FetchFailed", code: -1, userInfo: nil))
                    }
                }
            }
        }
    }
    
    private func saveAllRemoteConfigValues(_ remoteConfig: RemoteConfig) {
         let configKeys = defaultValues.keys
         
         for key in configKeys {
             let remoteValue = remoteConfig.configValue(forKey: key)
             if let defaultValue = defaultValues[key] {
                 saveConfigValue(remoteValue, forKey: key, defaultValue: defaultValue)
             }
         }
         
         UserDefaultsManager.shared.isConfigured = true
         print("Successfully applied all remote config values.")
     }
    
    private func saveMusicServiceConfig(_ remoteConfig: RemoteConfig) {
        let key = "music_service"
        let remoteValue = remoteConfig.configValue(forKey: key)
        
        if let defaultValue = defaultValues[key] {
            saveConfigValue(remoteValue, forKey: key, defaultValue: defaultValue)
        }
    
        print("Successfully updated music service configuration.")
    }
    
    private func saveConfigValue(_ remoteValue: RemoteConfigValue, forKey key: String, defaultValue: Any) {
        if defaultValue is String {
            let stringValue = remoteValue.stringValue
            UserDefaults.standard.set(stringValue, forKey: key)
        } else if defaultValue is Int {
            let intValue = remoteValue.numberValue.intValue
            if key == "free_start_generations" {
                if let existingData = KeychainService.shared.retrieveItem(
                    key: "free_start_generations",
                    itemClass: .generic,
                    as: Data.self
                ),
                   let existingValue = String(data: existingData, encoding: .utf8),
                   let existingIntValue = Int(existingValue) {
                    
                    print("Keychain already has value: \(existingIntValue), skipping overwrite")
                    return
                }

                print("Setting keychain with new value: \(intValue)")
                let stringValue = "\(intValue)"
                if let data = stringValue.data(using: .utf8) {
                    do {
                        try KeychainService.shared.saveItem(
                            data,
                            key: "free_start_generations",
                            itemClass: .generic
                        )
                    } catch {
                        print("Keychain save error: \(error)")
                    }
                } else {
                    print("Failed to convert intValue to Data")
                }
            } else {
                UserDefaults.standard.set(intValue, forKey: key)
            }
        } else if defaultValue is Bool {
            let boolValue = remoteValue.boolValue
            UserDefaults.standard.set(boolValue, forKey: key)
        } else {
            print("Unhandled type for key: \(key)")
        }
    }
    
    private func applyDefaultValues() {
        for (key, defaultValue) in defaultValues {
            UserDefaults.standard.set(defaultValue, forKey: key)
        }
        UserDefaults.standard.synchronize()
        print("default values applied")
    }
}
