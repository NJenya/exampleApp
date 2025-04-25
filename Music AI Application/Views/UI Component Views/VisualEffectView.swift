//
//  VisualEffectView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 02.03.2025.
//

import Foundation
import SwiftUI

struct FigmaBlurView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(1)
            
            VisualEffectView(blurStyle: .systemUltraThinMaterialDark)
                .blur(radius: 20)
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style = .systemMaterialDark
    var opacity: CGFloat = 0.7
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let view = UIVisualEffectView(effect: blurEffect)
        
        view.alpha = opacity
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
        uiView.alpha = opacity
    }
}
