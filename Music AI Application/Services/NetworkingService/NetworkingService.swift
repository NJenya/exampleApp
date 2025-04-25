//
//  NetworkingService.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 20.02.2025.
//
//
//  NetworkingService.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 20.02.2025.
//

import Foundation

final class NetworkingService: NetworkingProtocol {
    
    private let requestBuilder = RequestBuilder()
    private let parser = Parser()
    
    func sendRequest(for model: MusicModel) async throws -> String? {
        print("UDIO IS being used")
        guard let request = requestBuilder.buildRequestForSongID(of: model) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        guard let songID = parser.parseID(from: data) else {
            throw NetworkError.invalidData
        }
        
        return songID
    }
    
    func getMusicData(with id: String) async throws -> GeneratedSong? {
        guard let request = requestBuilder.buildRequestForSongData(id: id) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        guard let result = try? JSONDecoder().decode(SongResponse.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result.songs.first ?? result.songs[1]
    }
}

struct SongResponse: Decodable {
    let songs: [GeneratedSong]
}

struct GeneratedSong: Decodable {
    let imagePath: String
    let songPath: String
    let duration: Double
    
    enum CodingKeys: String, CodingKey {
        case imagePath = "image_path"
        case songPath = "song_path"
        case duration
    }
}

// MARK: - Parser

class Parser {
    func parseID(from data: Data) -> String? {
        do {
            let decodedData = try JSONDecoder().decode(StatusResponse.self, from: data)
            return decodedData.trackIDs.first
        } catch {
            print("Decoding Error: \(error.localizedDescription)")
            return nil
        }
    }
}

struct StatusResponse: Decodable {
    let message: String
    let generationID: String
    let trackIDs: [String]
    
    enum CodingKeys: String, CodingKey {
        case message
        case generationID = "generation_id"
        case trackIDs = "track_ids"
    }
}

// MARK: - Request Builder

class RequestBuilder {
    let baseURL = "https://api.sunoaiapi.com/api/v1/udio"
    let apiKey = ""
    let BaseURLForGET = "https://www.udio.com/api/songs?songIds="
    
    func buildRequestForSongID(of model: MusicModel) -> URLRequest? {
        guard let url = URL(string: "\(self.baseURL)/generate-proxy") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "api-key")
        
        
        let string = model.selectedStyles.map{ $0.lowercased()}.joined(separator: ", ")
        
        let requestBody: [String: Any] = [
            "gen_params": [
                "prompt": string,
                "lyrics": model.songLyrics,
                "lyrics_type": "user",
                "bypass_prompt_optimization": false,
                "seed": -1,
                "song_section_start": 0,
                "song_section_end": 1,
                "lyrics_placement_start": 0,
                "lyrics_placement_end": 0.95,
                "prompt_strength": 0.5,
                "clarity_strength": 0.25,
                "lyrics_strength": 0.5,
                "generation_quality": 0.75,
                "negative_prompt": "",
                "model_type": "udio130-v1.5",
                "config": ["mode": "regular"]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("❌ JSON Encoding Error: \(error)")
            return nil
        }
        return request
    }
    
    func buildRequestForSongData(id: String) -> URLRequest? {
        let baseURL = "\(self.BaseURLForGET)"
        
        guard let encodedID = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)\(encodedID)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.apiKey, forHTTPHeaderField: "api-key")
        
        return request
    }
}
