//
//  MusicStylesView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 24.01.2025.
//

import SwiftUI

struct MusicStylesView: View {
    var styles: [MusicStyle] = MusicStyleListEnum.allCases.map {
        MusicStyle(name: $0.rawValue, imageName: $0.rawValue.camelCased(), isSelected: false)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStyles: [String]
    let onDismiss: () -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack (spacing: 0){
            ZStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        onDismiss()
                    }) {
                        Image("left-arrow-icon")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                Text("Music Styles")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 24)
            
            ScrollView (.vertical, showsIndicators: false){
                LazyVGrid(columns: columns, spacing: 8 ) {
                    ForEach(styles) { style in
                        MusicStyleCard(
                            style: style,
                            cardHeight: 24,
                            isSelected: selectedStyles.contains(style.name),
                            fontSize: 10
                        )
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            appendMusicStyle(name: style.name)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(
            Image("backgroundImage")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
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
