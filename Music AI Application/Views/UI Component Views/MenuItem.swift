//
//  MenuItem.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 30.01.2025.
//

import SwiftUI

struct MenuItem: View {
    var title: String
    var icon: String
    var color: Color = .white
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                
                Spacer()
                
                Image(icon)
                    .foregroundColor(color)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14.5)
        }
    }
}
