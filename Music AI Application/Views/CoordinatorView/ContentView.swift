//
//  ContentView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 06.03.2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State var hasCompletedOnboarding = UserDefaultsManager.shared.isWelcomeTourCompleted
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if !hasCompletedOnboarding {
                    WelcomeView(path: $navigationPath)
                }else{
                    TabBarView(path: $navigationPath)
                }
            }
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    print("App is Active")
                case .inactive:
                    UserDefaults.standard.synchronize()
                case .background:
                    saveSongsLeftToKeychain()
                    UserDefaults.standard.synchronize()
                @unknown default:
                    print("Unknown state")
                }
            }
            .navigationDestination(for: MainScreens.self) { screen in
                switch screen {
                case .premium:
                    PremiumView(
                        path: $navigationPath,
                        isFromOnboarding: true,
                        onDismiss: {
                            UserDefaultsManager.shared.isWelcomeTourCompleted = true
                            navigationPath.removeLast()
                        }
                    )
                    .navigationBarBackButtonHidden()
                case .tabbar:
                    TabBarView(path: $navigationPath)
                        .navigationBarBackButtonHidden()
                default:
                    EmptyView()
                }
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
