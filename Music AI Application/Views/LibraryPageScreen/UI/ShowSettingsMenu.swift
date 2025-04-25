//
//  ShowSettingsMenu.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 28.01.2025.
//

import SwiftUI

enum SettingsOption: String, CaseIterable {
    case rename = "Rename"
    case share = "Share"
    case download = "Download"
    case delete = "Delete"

    var imageName: String {
        self.rawValue.lowercased()
    }
}

struct ShowSettingsMenu: View {
    var onSelect: (SettingsOption) -> Void
    let inSongPage: Bool
    
    var filteredOptions: [SettingsOption] {
        SettingsOption.allCases.filter { !(inSongPage && $0 == .share) }
    }
    
    var body: some View {
        Menu {
            ForEach(filteredOptions, id: \.self) { option in
                Button(action: {
                    onSelect(option)
                }) {
                    HStack {
                        Text(option.rawValue)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(option.imageName)
                    }
                }
            }
        } label: {
            Image("three-dots-icon")
                .frame(width: 32, height: 32)
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

#Preview {
    ShowSettingsMenu(onSelect: {_ in }, inSongPage: true)
}
