//
//  GenerateButton.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 16.01.2025.
//

import SwiftUI

struct GenerateButton: View {
    let iconName: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 21)
                    .foregroundColor(Color(
                        red: 48 / 255.0,
                        green: 1 / 255.0,
                        blue: 76 / 255.0,
                        opacity: 1.0
                    ))
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(
                        red: 48 / 255.0,
                        green: 1 / 255.0,
                        blue: 76 / 255.0,
                        opacity: 1.0
                    ))
            }
            .frame(width: 343, height: 56)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .background(.white)
            .cornerRadius(28)
        }
    }
}

#Preview {
    GenerateButton(iconName: "star.fill", text: "Generate my song") {
        print("Button tapped!")
    }
}
