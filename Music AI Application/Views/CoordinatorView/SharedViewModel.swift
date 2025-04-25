//
//  SharedViewModel.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 05.03.2025.
//

import Foundation
import SwiftUI
import Combine

final class SharedViewModel: ObservableObject {
    @Published var selectedTab: Int  = 0
    @Published var sharedData: MusicModel?  
    
    let songAddedPublisher = CurrentValueSubject<MusicModel?, Never>(nil)

    func updateSharedData(newData: MusicModel) {
        sharedData = newData
        songAddedPublisher.send(sharedData)
        sharedData = nil
    }
}
