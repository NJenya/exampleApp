//
//  CancelGenerationButton.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 28.01.2025.
//

import SwiftUI

struct CancelGenerationButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.white)
        }
        .frame(width: 230, height: 44)
        .background(.white.opacity(0.1))
        .background(.thinMaterial)
        .cornerRadius(22)
    }
}

#Preview {
    CancelGenerationButton(text: "Cancel generation") {
        print("hey")
    }
    .background(.black)
}
