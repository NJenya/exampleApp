//
//  Music_AI_ApplicationApp.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 06.12.2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Task {
            await fetchConfigs()
            loadStoredSongs()
        }
    
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveSongsLeftToKeychain()
    }
    
    private func fetchConfigs() async {
        do {
            if UserDefaultsManager.shared.isConfigured {
                try await ConfigManager().fetchMusicServiceConfig()
            } else {
                try await ConfigManager().fetchRemoteConfig()
            }
        } catch {
            print("Failed to fetch remote config: \(error)")
        }
    }
    
    private func loadStoredSongs() {
        do {
            if let storedData = KeychainService.shared.retrieveItem(
                key: "free_start_generations",
                itemClass: .generic,
                as: Data.self
            ),
               let storedValue = String(data: storedData, encoding: .utf8),
               let songsLeft = Int(storedValue) {
                UserDefaultsManager.shared.songsLeft = songsLeft
            }
        }
    }
    
    private func saveSongsLeftToKeychain() {
        let songsLeft = UserDefaultsManager.shared.songsLeft
        guard let data = "\(songsLeft)".data(using: .utf8) else {
            print("Failed to convert songsLeft to Data")
            return
        }
        
        do {
            try KeychainService.shared.saveItem(
                data,
                key: "free_start_generations",
                itemClass: .generic
            )
        } catch {
            print("Failed to save songsLeft to Keychain: \(error)")
        }
        print("Saved successfully to keychain when quit")
    }
}

@main
struct Music_AI_ApplicationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreen()
                    .preferredColorScheme(.dark)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            showLaunchScreen = false
                        }
                    }
            } else {
                ContentView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
