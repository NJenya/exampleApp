//
//  SongPageView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 30.01.2025.
//

import SwiftUI

struct SongPageView: View {
    let model: LibrarySongModel
    @State var songCurrentTime: String = "0:00"
    let onDismiss: () -> Void
    @StateObject private var player: SongPlayer

    init(model: LibrarySongModel, onDismiss: @escaping () -> Void) {
        self.model = model
        _player = StateObject(wrappedValue: SongPlayer(model: model))
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack (spacing: 0){
            SongPageNavBarView(model: model, onDismiss: {onDismiss()})
            Spacer()
                        
            VStack(spacing: 8) {
                Slider(value: $player.currentTime, in: 0.0...player.duration, onEditingChanged: { isEditing in
                    if !isEditing {
                        player.seekToTime(player.currentTime)
                    }
                })
                    .accentColor(.white)
                HStack{
                    Text(formatTime(player.currentTime))
                        .foregroundColor(.white)
                        .font(.dmSans(size: 12, weight: .medium))
                    Spacer()
                    
                    Text(model.durationString)
                        .foregroundColor(.white)
                        .font(.dmSans(size: 12, weight: .medium))
                }
            }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

            SongControlButtonsView(
                backwardAction: player.seekBackward,
                forwardAction: player.seekForward,
                playPauseAction: player.playPause,
                shareAction: player.shareSong,
                showLyricsAction: {player.showLyrics.toggle()},
                isPlaying: $player.isPlaying,
                isLyricsHidden: $player.showLyrics
            )
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(model.songImageName + "_full")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private func formatTime(_ seconds: Double) -> String {
         let mins = Int(seconds) / 60
         let secs = Int(seconds) % 60
         return String(format: "%d:%02d", mins, secs)
     }
}

struct SongPageNavBarView: View {
    let model: LibrarySongModel
    let onDismiss: () -> Void
    
    var body: some View {
        HStack (alignment: .top){
            Button(action: {
                onDismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.1))
                    .clipShape(.circle)
            }
            
            Spacer()
            
            VStack (spacing: 2){
                Text(model.songTitle)
                    .font(.dmSans(size: 28, weight: .medium))
                    .foregroundColor(.white)
                
                Text(model.genreString)
                    .font(.dmSans(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                print("Menu button pressed")
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.1))
                    .clipShape(.circle)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 63)
        .padding(.horizontal, 16)
    }
    
    private var showMenuButtonView: some View {
            ShowSettingsMenu(
                onSelect: { selected in
                },
                inSongPage: false
            )
            .background(
                Color.white.opacity(0.15)
                    .blur(radius: 20)
            )
            .clipShape(Circle())
    }
    
}
