//
//  DarkBackgrounForAlerts.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 18.03.2025.
//

import Foundation
import SwiftUI

struct DarkBackgroundForAlerts: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
}
