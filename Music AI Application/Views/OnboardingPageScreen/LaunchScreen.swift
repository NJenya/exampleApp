////
////  LaunchScreen.swift
////  Music AI Application
////
////  Created by Мерей Булатова on 02.02.2025.
////
//
//import SwiftUI
//import AVKit
//
//struct LaunchScreen: View {
//    
//    @State private var isFinished = false
//    
//    var body: some View {
//        ZStack {
//            if !isFinished {
//                VideoPlayerView(videoName: "splash-icon")
//                    .frame(width: 200, height: 200)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                            withAnimation {
//                                isFinished.toggle()
//                            }
//                        }
//                    }
//            } else {
//                WelcomeView()
//                    .transition(.opacity)
//            }
//        }
//    }
//}
//
//struct VideoPlayerView: UIViewControllerRepresentable {
//    
//    var videoName: String
//    
//    func makeUIViewController(context: Context) -> AVPlayerViewController {
//        let controller = AVPlayerViewController()
//        if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
//            let player = AVPlayer(url: URL(fileURLWithPath: path))
//            controller.player = player
//            controller.showsPlaybackControls = false
//            player.play()
//        }
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
//}
//
//struct SplashScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LaunchScreen()
//    }
//}

import SwiftUI
import AVKit

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: "splash-icon")
                .frame(width: 200, height: 200)
        }
        .background(.black)
    }
}

struct VideoBackgroundView: UIViewRepresentable {
    var videoName: String

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        guard let path = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
            return containerView
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = containerView.bounds
        containerView.layer.addSublayer(playerLayer)
        
        player.play()
        
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
