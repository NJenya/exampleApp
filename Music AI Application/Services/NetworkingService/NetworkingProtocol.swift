//
//  NetworkingProtocol.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 21.03.2025.
//

import Foundation

protocol NetworkingProtocol {
    func sendRequest(for model: MusicModel) async throws -> String?
    func getMusicData(with id: String) async throws -> GeneratedSong?
}
