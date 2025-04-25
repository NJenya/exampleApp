//
//  ModalAlertView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 30.01.2025.
//

import SwiftUI

struct ModalAlertView: View {
    let songsLeft: Int
    let onGetPremium: () -> Void
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack (spacing: 20) {
            ZStack(alignment: .top) {
                BadgeSongsLeft(songsLeft: songsLeft, action: {})
                    .padding(.top, 20)
                
                HStack(alignment: .top) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("close")
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(10)
                            .background(Color.clear)
                    }
                    .contentShape(Rectangle())
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.leading, 10)
            }
            
            
            VStack (spacing: 8) {
                Text(songsLeft > 0 ? "You have \(songsLeft) Generations Left" :
                        "You’re Run Out of Generations"
                )
                .foregroundColor(.white)
                .font(.dmSans(size: 18, weight: .bold))
                
                Text(
                    songsLeft > 0 ? "You can generate \(songsLeft) songs for free.\nUpgrade to Premium for unlimited creations."
                    : "Your free song generations are all used up.\nUpgrade to Premium for unlimited creations."
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.dmSans(size: 12, weight: .regular))
            }
            .padding(.horizontal, 20)
            
            
            Button(action: {
                dismiss()
                onGetPremium()
            }){
                HStack (alignment: .center, spacing: 8){
                    Image("white-crown-icon")
                    Text("Get Premium")
                        .foregroundColor(.white)
                        .font(.dmSans(size: 18, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(
                LinearGradient(
                    colors: [Color(red: 204/255, green: 0/255, blue: 255/255),
                             Color(red: 204/255, green: 255/255, blue: 0/255)],
                    startPoint: .trailing,
                    endPoint: .leading
                )
                .ignoresSafeArea()
            )
            .cornerRadius(28)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                FigmaBlurView()
            }
        )
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
    }
    
    func dismiss() {
        isPresented = false
    }
}
