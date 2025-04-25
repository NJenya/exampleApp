//
//  NetworkingService2.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 21.03.2025.
//
import Foundation

final class NetworkingService2: NetworkingProtocol {
    private let baseURL = "https://api.sunoaiapi.com/api/v1/gateway/generate/music"
    private let apiKey = ""
    
    func sendRequest(for model: MusicModel) async throws -> String? {
        print("UDIO IS being used")
        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
        
        let requestModel = RequestModel(
            title: model.songName,
            tags: model.selectedStyles.joined(separator: ","),
            generationType: "TEXT",
            prompt: model.songLyrics,
            negativeTags: nil,
            mv: nil,
            continueAt: nil,
            continueClipID: nil
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "api-key")
        request.httpBody = try JSONEncoder().encode(requestModel)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let songResponse = try JSONDecoder().decode(SongIDResponse.self, from: data)
        let id = songResponse.data.first?.songID
        print("IDS: \(id)")
        return id
    }
    
    func getMusicData(with id: String) async throws -> GeneratedSong? {
        let urlString = "https://api.sunoaiapi.com/api/v1/gateway/query?ids=\(id)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let songArray = try JSONDecoder().decode([SongDataResponse2].self, from: data)
        
        guard let songData = songArray.first else { return nil }
        
        let result = GeneratedSong(
            imagePath: songData.imageURL,
            songPath: songData.audioURL,
            duration: songData.metaData.duration
        )
        
        print(result)
        return result
    }
}

struct RequestModel: Codable {
    let title: String
    let tags: String
    let generationType: String?
    let prompt: String
    let negativeTags: String?
    let mv: String?
    let continueAt: Float?
    let continueClipID: String?
}

struct SongIDResponse: Decodable {
    let code: Int
    let msg: String
    let data: [SongData]
}

struct SongData: Decodable {
    let songID: String
    let status: String
    let title: String
    let imageLargeURL: String?
    let imageURL: String?
    let modelName: String
    let videoURL: String?
    let audioURL: String?
    let metaTags: String
    let metaPrompt: String
    let metaDuration: Double?
    let metaErrorMsg: String?
    let metaErrorType: String?
    
    enum CodingKeys: String, CodingKey {
        case songID = "song_id"
        case status, title
        case imageLargeURL = "image_large_url"
        case imageURL = "image_url"
        case modelName = "model_name"
        case videoURL = "video_url"
        case audioURL = "audio_url"
        case metaTags = "meta_tags"
        case metaPrompt = "meta_prompt"
        case metaDuration = "meta_duration"
        case metaErrorMsg = "meta_error_msg"
        case metaErrorType = "meta_error_type"
    }
}

struct SongDataResponse2: Decodable {
    let id: String
    let title: String
    let metaData: MetaData
    let audioURL: String
    let imageURL: String
    let videoURL: String?

    enum CodingKeys: String, CodingKey {
        case id, title, metaData = "meta_data"
        case audioURL = "audio_url"
        case imageURL = "image_url"
        case videoURL = "video_url"
    }
}

struct MetaData: Decodable {
    let tags: String
    let prompt: String
    let duration: Double
}
