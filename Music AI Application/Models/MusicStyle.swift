//
//  MusicStyle.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 24.01.2025.
//

import Foundation

struct MusicStyle: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    var isSelected: Bool
}

enum MusicStyleListEnum: String, CaseIterable {
    case pop = "Pop"
    case hipHop = "Hip-Hop"
    case electronic = "Electronic"
    case rock = "Rock"
    case rnb = "R&B"
    case rap = "Rap"
    case house = "House"
    case techno = "Techno"
    case metal = "Metal"
    case jazz = "Jazz"
    case classical = "Classical"
    case funk = "Funk"
    case soul = "Soul"
    case trance = "Trance"
    case punk = "Punk"
    case blues = "Blues"
    case reggae = "Reggae"
    case synthwave = "Synthwave"
    case grunge = "Grunge"
    case newWave = "New Wave"
    case loFiHipHop = "Lo-fi Hip-Hop"
    case drumAndBass = "Drum and Bass"
    case dubstep = "Dubstep"
    case disco = "Disco"
    case ska = "Ska"
    case neoSoul = "Neo-Soul"
    case ambient = "Ambient"
    case garageRock = "Garage Rock"
    case industrial = "Industrial"
    case country = "Country"
    case kPop = "K-Pop"
    case latin = "Latin"
    case indie = "Indie"
    case reggaeton = "Reggaeton"
    case folk = "Folk"
    case afrobeat = "Afrobeat"
    case arabic = "Arabic"
    case bossaNova = "Bossa Nova"
    case dreamPop = "Dream Pop"
    case celtic = "Celtic"
    case gospel = "Gospel"
    case bachata = "Bachata"
    case salsa = "Salsa"
    case tango = "Tango"
    case italoDisco = "Italo Disco"
    case glitch = "Glitch"
    case downtempo = "Downtempo"
    case hyperPop = "Hyper Pop"
}
