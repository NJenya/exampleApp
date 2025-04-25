//
//  ActivityIndicator.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 04.03.2025.
//

import SwiftUI

final class LoaderManager {
    static let shared = LoaderManager()
    
    private var backgroundView: UIView?
    private var spinner: UIActivityIndicatorView?
    
    func show() {
        DispatchQueue.main.async {
            if self.spinner == nil, let window = self.getKeyWindow() {
                self.createBackgroundView(in: window)
                self.createSpinner(in: window)
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView?.alpha = 0.0
                self.spinner?.alpha = 0.0
            }, completion: { _ in
                self.spinner?.removeFromSuperview()
                self.backgroundView?.removeFromSuperview()
                self.spinner = nil
                self.backgroundView = nil
            })
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    private func createBackgroundView(in window: UIWindow) {
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundView.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            backgroundView.alpha = 1.0
        }
        window.addSubview(backgroundView)
        self.backgroundView = backgroundView
    }
    
    private func createSpinner(in window: UIWindow) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = window.center
        spinner.color = .white
        spinner.startAnimating()
        window.addSubview(spinner)
        self.spinner = spinner
    }
}
