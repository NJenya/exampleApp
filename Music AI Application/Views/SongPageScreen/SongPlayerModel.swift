//
//  SongPlayerModel.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 13.03.2025.
//
import AVFoundation
import Combine
import UIKit

class SongPlayer: ObservableObject {
    @Published var currentTime: Double = 0.0
    @Published var duration: Double = 1.0
    @Published var isPlaying: Bool = false
    @Published var showLyrics: Bool = false
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private let model: LibrarySongModel
    
    init(model: LibrarySongModel) {
        self.model = model
        if let url = URL(string: model.audioURL ?? "") {
            player = AVPlayer(url: url)
            setupPlayerObserver()
            setupEndObserver()
        }
    }

    func playPause() {
        guard let player = player else { return }
        print("Playing")
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    func seekForward() {
        guard let player = player else { return }
        let current = player.currentTime().seconds
        let newTime = min(current + 10, duration)
        seek(to: newTime)
    }

    func seekBackward() {
        guard let player = player else { return }
        let current = player.currentTime().seconds
        let newTime = max(current - 10, 0)
        seek(to: newTime)
    }

    private func seek(to time: Double) {
        guard let player = player else { return }
        let newCMTime = CMTime(seconds: time, preferredTimescale: 1)
        player.seek(to: newCMTime, completionHandler: { [weak self] _ in
            DispatchQueue.main.async {
                self?.currentTime = time
            }
        })
    }
    
    func seekToTime(_ time: Double) {
        guard let player = player else { return }
        let newTime = min(max(time, 0), duration)
        seek(to: newTime)
        if !isPlaying {
            playPause() 
        }
    }


    private func setupPlayerObserver() {
        guard let player = player else { return }

        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            if let duration = player.currentItem?.duration.seconds, duration.isFinite {
                self.duration = duration
            }
        }
    }
    
    func shareSong() {
        guard let audioURLString = model.audioURL, let audioURL = URL(string: audioURLString) else {
            print("Invalid audio URL")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [audioURL], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func setupEndObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(songDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func songDidFinish() {
        DispatchQueue.main.async {
            self.currentTime = 0
            self.isPlaying = false
            self.player?.seek(to: .zero)
        }
    }

    deinit {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        NotificationCenter.default.removeObserver(self)
    }
}
