//
//  Constant.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 02.03.2025.
//

import Foundation

enum Constant: String {
    case appleID = "6504260709"
    
    static var appLink: String {
        "https://apps.apple.com/app/id\(Constant.appleID.rawValue)"
    }
    
    static var shareAppLink: String {
        "https://apps.apple.com/app/id\(Constant.appleID.rawValue)?action=write-review"
    }
}
