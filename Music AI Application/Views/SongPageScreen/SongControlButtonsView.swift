//
//  SongControlButtonsView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 30.01.2025.
//

import SwiftUI

struct SongControlButtonsView: View {
    let backwardAction: () -> Void
    let forwardAction: () -> Void
    let playPauseAction: () -> Void
    let shareAction: () -> Void
    let showLyricsAction: () -> Void
    @Binding var isPlaying: Bool
    @Binding var isLyricsHidden: Bool
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                showLyricsAction()
            }) {
                Image(isLyricsHidden ? "icon-hideText" : "text.justify.left")
                    .foregroundColor(.white)
            }
            .frame(width: 40, height: 40)
            .background(.white.opacity(0.1))
            .clipShape(.circle)
            .disabled(true)
            .opacity(0.5)
            
            Button(action: {
                backwardAction()
            }) {
                Image("10.arrow.trianglehead.counterclockwise")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
            }
            .frame(width: 40, height: 40)
            .background(.white.opacity(0.1))
            .clipShape(.circle)
            
            Button(action: {
                playPauseAction()
            }) {
                Image(systemName: !isPlaying ? "play.fill" : "pause.fill")
                    .font(.system(size: 38))
                    .foregroundColor(.white)
            }
            .frame(width: 64, height: 64)
            .background(.white.opacity(0.1))
            .clipShape(.circle)
            
            Button(action: {
                forwardAction()
            }) {
                Image("10.arrow.trianglehead.clockwise")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
            }
            .frame(width: 40, height: 40)
            .background(.white.opacity(0.1))
            .clipShape(.circle)
            
            
            Button(action: {
                shareAction()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
                    .font(.system(size: 21))
            }
            .frame(width: 40, height: 40)
            .background(.white.opacity(0.1))
            .clipShape(.circle)
        }
        .padding(.horizontal, 36)
    }
}
