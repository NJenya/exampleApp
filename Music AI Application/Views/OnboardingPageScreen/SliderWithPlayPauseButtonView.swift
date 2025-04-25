//
//  SliderWithPlayPauseButton.swift
//  Music AI Application
//
//  Created by Мерей Булатова on 17.01.2025.
//

import SwiftUI

struct SliderWithPlayPauseButtonView: View {
    @Binding var sliderValue: Double
    @State private var isPlaying: Bool = false
    var onPlayPauseTapped: (Bool) -> Void
    
    @State private var animationProgress: CGFloat = 0.0
    @State private var timer: Timer? = nil
    private let animationDuration: TimeInterval = 10.0
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 8)
                    .cornerRadius(12)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * animationProgress)
                    .frame(height: 8)
                    .cornerRadius(12)
                    .animation(.linear(duration: animationDuration), value: animationProgress)
            }
            .padding(.top, 40)
            
            Button(action: {
                isPlaying.toggle()
                onPlayPauseTapped(isPlaying)
                handlePlayPauseAction()
            }) {
                Image(isPlaying ? "pause-button" : "play-button")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .padding(12)
            }
            .zIndex(1)
            
        }
        .frame(height: 64)
        .padding(.horizontal, 16)
    }
    
    private func handlePlayPauseAction() {
        if isPlaying {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    private func startAnimation() {
        timer?.invalidate()
        
        let startTime = Date().timeIntervalSince1970
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let elapsedTime = Date().timeIntervalSince1970 - startTime
            let progress = min(CGFloat(elapsedTime / animationDuration), 1.0)
            
            animationProgress = progress
            
            if animationProgress >= 1.0 {
                timer?.invalidate()
            }
        }
    }

    private func stopAnimation() {
        timer?.invalidate()
    }
}
