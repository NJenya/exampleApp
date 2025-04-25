//
//  CancelGenerationAlertView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 28.01.2025.
//

import SwiftUI

struct CancelGenerationAlertView: View {
    let title: String
    let message: String
    let button1Text: String
    let button2Text: String
    let action1: () -> Void
    let action2: () -> Void
    
    var body: some View {
        VStack(spacing: 16){
            VStack(spacing: 4){
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)

            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
                        
            VStack(spacing: 8){
                Button(action: action1) {
                    Text(button1Text)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 204 / 255, green: 255 / 255, blue: 0 / 255))
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(.white.opacity(0.2))
                .cornerRadius(22)
                
                Button(action: action2) {
                    Text(button2Text)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(.white.opacity(0.2))
                .cornerRadius(22)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 270, maxHeight: 246)
        .background(.white.opacity(0.2))
        .background(.thinMaterial)
        .cornerRadius(20)

    }
}

#Preview {
    CancelGenerationAlertView(
        title: "Generation Taking Longer Than Usual",
        message: "Song generation is taking longer than usual. Cancel and try again? You won’t lose your free generations.",
        button1Text: "Cancel Generation",
        button2Text: "Wait Longer",
        action1: { print("Cancel pressed") },
        action2: { print("Wait Longer pressed") }
    )
    .background(.black)
}
