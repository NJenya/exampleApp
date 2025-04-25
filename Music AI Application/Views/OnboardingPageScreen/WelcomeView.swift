//
//  WelcomeView.swift
//  Music AI Application
//
//  Created by Мерей Булатова on 16.12.2024.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeModel()
    @State private var buttonOpacity = 1.0
    @State private var isContentVisible = false
    @State private var sliderValue = 0.0
    @State private var contentOffset: CGFloat = 0
    @Binding var path: NavigationPath

    var body: some View {
            ZStack {
                backgroundImage
                contentOverlay
            }
            .ignoresSafeArea()
            .onAppear{
                contentOffset = 0
            }
    }
    
    private var backgroundImage: some View {
        let (_, _, imageName) = viewModel.getHintAndImage()
        return Image(imageName)
            .resizable()
            .ignoresSafeArea()
            .animation(.easeInOut, value: viewModel.currentPage)
    }
    
    private var contentOverlay: some View {
        VStack {
            hintsAndSliderSection
            continueButton
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isContentVisible = true
            }
        }
        .opacity(isContentVisible ? 1 : 0)
    }
    
    private var hintsAndSliderSection: some View {
        let (hint, subHint, _) = viewModel.getHintAndImage()
        return VStack {
            if viewModel.currentPage == 0 {
                (Text(hint)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                 +
                 Text("AI ")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(UIColor(red: 0.80, green: 1.00, blue: 0.00, alpha: 1.00)))
                    .bold()
                 +
                 Text(subHint)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white))
                Spacer()
                SliderWithPlayPauseButtonView(sliderValue: $sliderValue) { isPlaying in
                    if isPlaying {
                        print("Playing...")
                    } else {
                        print("Paused...")
                    }
                }
                .padding(.bottom, 32)
            } else {
                Text(hint)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                Text(subHint)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
    
    private var continueButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                if !viewModel.increasePage() {
                    LoaderManager.shared.show()
                    path.append(MainScreens.premium)
                }
            }
        }) {
            Text("Continue")
                .foregroundStyle(Color(UIColor(red: 0.19, green: 0.00, blue: 0.30, alpha: 1.00)))
                .bold()
                .font(.dmSans(size: 18, weight: .regular))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(28)
        .padding(.horizontal, 16)
        .padding(.bottom, 101)
        .opacity(buttonOpacity)
        .animation(.easeInOut(duration: 0.15), value: buttonOpacity)
        .onTapGesture {
            buttonOpacity = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                buttonOpacity = 1.0
            }
        }
        .zIndex(1)
    }
}
