//
//  SettingsCellView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 13.02.2025.
//

import SwiftUI

struct SettingsCellView: View {
    let imageName: String
    let name: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: imageName)
                .foregroundColor(.white)
                .padding(.leading, 20)
            
            Text(name)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 21))
                .foregroundColor(.white)
                .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color.white.opacity(0.2))
        .clipShape(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
    }
}

struct Settings: Identifiable {
    var id = UUID()
    let imageName: String
    let name: String
}

#Preview {
    SettingsCellView(imageName: "starSt", name: "Rate us")
        .background(.black)
}
