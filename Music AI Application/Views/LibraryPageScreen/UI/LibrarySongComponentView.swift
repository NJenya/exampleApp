//
//  LibrarySongComponentView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 27.01.2025.
//

import SwiftUI

struct LibrarySongComponentView: View {
    let songModel: LibrarySongModel
    let playAction: () -> Void
    let menuAction: () -> Void
    @Binding var selectedOption: SettingsOption?
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            if !songModel.isLoading{
                HStack(spacing: 0) {
                    albumArtView
                    songInfoView
                    Spacer()
                    durationView
                }
                .background(Color.white.opacity(0.15)).cornerRadius(20)
            }else {
                HStack(spacing: 0) {
                    albumArtView
                    songInfoView
                    Spacer()
                }
                .background(Color.white.opacity(0.15)).cornerRadius(20)
                .overlay {
                    Color.black.opacity(0.2).cornerRadius(20)
                }
            }
            
            if songModel.isLoading {
                loaderView
                    .padding(.top, 4)
                    .padding(.trailing, 4)
            }else {
                showMenuButtonView
                    .padding(.top, 4)
                    .padding(.trailing, 4)
            }
        }
        .frame(height: 88)
    }

    // MARK: - Album Art with Play Button
    private var albumArtView: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(songModel.songImageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
            if !songModel.isLoading {
                playButton
            }
        }
        .padding(.leading, 4)
        .padding(.vertical, 4)
    }
    
    // MARK: - Play Button
    private var playButton: some View {
        Button(action: {
            playAction()
        }) {
            Image("playButton-icon")
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
                .background(
                    Color.black.opacity(0.3)
                        .blur(radius: 20)
                )
                .background(.thinMaterial)
        }
        .clipShape(Circle())
        .padding(.trailing, 2)
        .padding(.bottom, 2)
        .contentShape(Circle())
    }
    
    // MARK: - Song Info (Title & Genre)
    private var songInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(songModel.songTitle)
                .font(.dmSans(size: 18, weight: .regular))
                .foregroundColor(.white)
            
            Text(songModel.genreString)
                .font(.dmSans(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.leading, 16)
        .padding(.vertical, 20)
    }
    
    // MARK: - Song Duration
    private var durationView: some View {
        VStack {
            Spacer()
            Text("\(getFormattedTime())")
                .font(.dmSans(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
                .padding(.trailing, 36)
                .padding(.bottom, 22)
        }
    }
    // MARK: - Menu Button

    private var showMenuButtonView: some View {
            ShowSettingsMenu(
                onSelect: { selected in
                    menuAction()
                    selectedOption = selected
                },
                inSongPage: false
            )
            .background(
                Color.white.opacity(0.15)
                    .blur(radius: 20)
            )
            .clipShape(Circle())
            .padding(.trailing, 4)
            .padding(.top, 4)
    }
    
    private var loaderView: some View {
        Image("icon-loader")
            .background(
                Color.white.opacity(0.15)
                    .blur(radius: 20)
            )
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            .padding(.trailing, 4)
            .padding(.top, 4)
            .contentShape(Circle())
    }
    
    func getFormattedTime() -> String {
        let totalSeconds = Int(songModel.duration ?? 0.0)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }

}
