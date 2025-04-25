//
//  NetworkingServiceFactory.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 21.03.2025.
//

final class MusicServiceFactory {
    static func createMusicService(using apiType: APIType) -> NetworkingProtocol {
        switch apiType {
        case .api1:
            return NetworkingService()
        case .api2:
            return NetworkingService2()
        }
    }
}

enum APIType: String {
    case api1 = "UdioAI"
    case api2 = "SunoAI"
}
