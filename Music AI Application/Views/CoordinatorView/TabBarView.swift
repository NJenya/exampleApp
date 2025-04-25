//
//  CoordinatorView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 16.12.2024.
//
import SwiftUI

struct TabBarView: View {
//    @State private var selectedTab: Int = 0
//    @State private var hideTabBar: Bool = false
//    @StateObject private var sharedViewModel = SharedViewModel()
//    let context = CoreDataManager.shared.context
//    @Binding var path: NavigationPath
//    
//    @StateObject private var libraryViewModel = LibraryViewModel(
//        context: CoreDataManager.shared.context,
//        sharedViewModel: sharedViewModel
//    )
    
    @StateObject private var sharedViewModel: SharedViewModel
    @StateObject private var libraryViewModel: LibraryViewModel
    @State private var selectedTab: Int = 0
    @State private var hideTabBar: Bool = false
    @Binding var path: NavigationPath
    let context = CoreDataManager.shared.context

    init(path: Binding<NavigationPath>) {
        let shared = SharedViewModel()
        _sharedViewModel = StateObject(wrappedValue: shared)
        _libraryViewModel = StateObject(
            wrappedValue: LibraryViewModel(
                context: CoreDataManager.shared.context,
                sharedViewModel: shared,
                apiType: APIType(rawValue: UserDefaultsManager.shared.music_service) ?? .api1
            )
        )
        _path = path
    }

    var body: some View {
        VStack {
            ZStack {
                switch selectedTab {
                case 0:
                    MainPageView(hideTabBar: $hideTabBar, selectedTab: $selectedTab, path: $path)
                        .environmentObject(sharedViewModel)
                case 1:
                    LibraryView(
                        hideTabBar: $hideTabBar,
                        viewModel: libraryViewModel,
                        path: $path
                    )
                    .environment(\.managedObjectContext, context)
                case 2:
                    SettingsView(path: $path, hideTabBar: $hideTabBar)
                default:
                    MainPageView(hideTabBar: $hideTabBar, selectedTab: $selectedTab, path: $path)
                        .environmentObject(sharedViewModel)
                }
                Spacer()
                if !hideTabBar{
                    CustomTabBarView(selectedTab: $selectedTab)
                        .padding(.bottom, 10)
                        .ignoresSafeArea(.keyboard)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


