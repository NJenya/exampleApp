//
//  MusicStylesView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 21.01.2025.
//

import SwiftUI

struct MusicStylesComponentView: View {
    var styles: [MusicStyle] = MusicStyleListEnum.allCases.map {
        MusicStyle(name: $0.rawValue, imageName: $0.rawValue.camelCased(), isSelected: false)
    }
    
    @Binding var selectedStyles: [String]
    let actionNavigate: () -> Void
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Text("Select Styles")
                    .padding(.leading, 32)
                    .foregroundColor(.white)
                    .font(.dmSans(size: 18, weight: .regular))
                Spacer()
                Button(action: {
                    actionNavigate()
                }) {
                    HStack(spacing: 0){
                        Text("See all")
                            .font(.dmSans(size: 12, weight: .medium))
                        
                        Image("right-arrow-icon")
                            .padding(.vertical, 1)
                            .padding(.leading, 4)
                    }
                    .foregroundColor(.white)
                }
                .padding(.trailing, 16)
            }
            .padding(.bottom, 14)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(styles) { style in
                        MusicStyleCard(
                            style: style,
                            isSelected: selectedStyles.contains(style.name)
                        )
                        .frame(width: 127, height: 127)
                        .onTapGesture {
                            appendMusicStyle(name: style.name)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 24)
    }
    
    private func appendMusicStyle(name: String){
        if selectedStyles.contains(name){
            if selectedStyles.count > 1 {
                selectedStyles.removeAll {$0 == name}
            }
        }else {
            selectedStyles.append(name)
        }
        UserDefaultsManager.shared.selectedStyle = selectedStyles
    }
}

struct MusicStyleCard: View {
    let style: MusicStyle
    var cardHeight: CGFloat = 32
    var isSelected: Bool = false
    var fontSize: CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .bottom){
            Image(style.imageName)
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
            HStack(alignment: .center, spacing: 0){
                if isSelected{
                    Image("checkMarkIcon")
                        .padding(.trailing, 2)
                }
                Text(style.name)
                    .font(.dmSans(size: fontSize, weight: .medium))
                    .foregroundColor(.white)
                
            }
            .frame(maxWidth: .infinity, minHeight: cardHeight)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .padding(.bottom, 4)
            .padding(.horizontal, 4)
        }
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
    
}

#Preview(){
    MusicStyleCard(style: MusicStyle(name: "Pop", imageName: "pop", isSelected: false))
}
