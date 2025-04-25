//
//  MainPageView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 01.03.2025.
//

import SwiftUI

struct MainPageView: View {
    @StateObject private var model = MainPageModel()
    @Binding var hideTabBar: Bool
    @Binding var selectedTab: Int
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @Binding var path: NavigationPath
    
    
    private let networking = NetworkingService()
    
    // MARK: - Body
    var body: some View {
        ZStack{
            ScrollView {
                if !model.isEditingLyrics {
                    mainContentView
                }else {
                    VStack {
                        LyricsEditorView()
                            .environmentObject(model)
                    }
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 16)
                    }
                }
            }
            .scrollDisabled(false)
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                model.isEditingName = false
            }
            .navigationDestination(
                isPresented: $model.navigateToMusicStyles,
                destination: {
                    MusicStylesView(
                        selectedStyles: $model.selectedStyles,
                        onDismiss: {
                            hideTabBar = false
                        }
                    ).navigationBarBackButtonHidden()
                })
            
            .fullScreenCover(isPresented: $model.navigateToPremiumFromNavBar) {
                PremiumView(
                    path: $path,
                    isFromOnboarding: false,
                    onDismiss: {
                        model.navigateToPremiumFromNavBar = false
                    })
            }
            .fullScreenCover(isPresented: $model.navigateToPremiumFromModalAlertView) {
                PremiumView(
                    path: $path,
                    isFromOnboarding: false,
                    onDismiss: {
                        model.navigateToPremiumFromModalAlertView = false
                    }
                )
            }
            .customAlert(
                "Generate Music Without Lyrics?",
                isPresented: $model.showNoLyricsAlert,
                actionText: "Generate",
                action: {_ in
                    model.generateWithNoLyrics = true
                    prepareModelAndGenerate()
                },
                alertType: .noLyricsGenerate,
                model: nil
            )
            
            .customAlert(
                "Your Song Is Generating",
                isPresented: $model.showGeneratingAlert,
                actionText: "Go to Library",
                action: {_ in
                    selectedTab = 1
                },
                alertType: .generatingMusic,
                model: nil
            )
            
            .modalAlert(
                songsLeft: model.songsLeft,
                isPresented: $model.showModalAlertView,
                action: {
                    model.navigateToPremiumFromModalAlertView = true
                    LoaderManager.shared.show()
                }
            )
            .onChange(of: model.showModalAlertView) { isPresented in
                hideTabBar = isPresented
            }
            
            .alert("Alert with OOPS", isPresented: $model.exceededDailyLimit) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("I WILL IMPLEMENT IT LATER")
            }
            
            .alert("Show alert that says free generations ended", isPresented: $model.showLimitIsFinished) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("I WILL IMPLEMENT IT LATER")
            }
        }
        .background(){
            backgroundView
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        Image("backgroundImage")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    // MARK: - Main Content View
    private var mainContentView: some View {
        VStack(spacing: 0) {
            AppNavigationBarView(
                songsLeft: $model.songsLeft,
                titleName: "AI Music",
                songsLeftAction: {
                    model.showModalAlertView = true
                },
                onPremiumButtonPush: {
                    model.navigateToPremiumFromNavBar = true
                    LoaderManager.shared.show()
                }
            )
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 11) }
            
            SongNameEditorView(songName: $model.songName, isSongNameEditing: $model.isEditingName)
                .onTapGesture {
                    model.isEditingName = true
                }
                .onSubmit {
                    model.isEditingName = false
                }
            
            LyricsEditorView()
                .environmentObject(model)
                .onTapGesture {
                    model.isEditingName = false
                }
            
            MusicStylesComponentView(
                selectedStyles: $model.selectedStyles,
                actionNavigate: {
                    hideTabBar = true
                    model.navigateToMusicStyles = true
                }
            )
            
            GenerateButton(iconName: "generate-stars-icon", text: "Generate my song") {
//                let newSong = MusicModel(
//                    songName: model.songName.isEmpty ? model.getName() : model.songName,
//                    selectedStyles: model.selectedStyles,
//                    songLyrics: model.savedLyrics,
//                    songID: UUID()
//                )
//                let isGenerated = generateMusicButtonTapped(music: newSong)
//                if isGenerated {
//                    sharedViewModel.updateSharedData(newData: newSong)
//                }
                prepareModelAndGenerate()
            }
            
            Spacer()
        }
    }
    
    private func prepareModelAndGenerate() {
        let newSong = MusicModel(
            songName: model.songName.isEmpty ? model.getName() : model.songName,
            selectedStyles: model.selectedStyles,
            songLyrics: model.savedLyrics,
            songID: UUID()
        )
        let isGenerated = model.handleGenerateMusic(model: newSong)
        if isGenerated {
            sharedViewModel.updateSharedData(newData: newSong)
        }
    }
    
    private func generateMusicButtonTapped (music: MusicModel) -> Bool {
        return model.handleGenerateMusic(model: music)
    }
}

