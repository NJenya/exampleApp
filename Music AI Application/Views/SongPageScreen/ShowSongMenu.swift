//
//  ShowSongMenu.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 30.01.2025.
//


import SwiftUI

struct ShowSongMenu: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showMenu = false
                    }
                }
            
            VStack(alignment: .leading, spacing: 0) {
                MenuItem(title: "Rename", icon: "rename", action: {
                    print("Rename tapped")
                    showMenu = false
                })
                
                Divider().background(Color.white.opacity(0.2))
                
                MenuItem(title: "Download", icon: "download", action: {
                    print("Download tapped")
                    showMenu = false
                })
                
                Divider().background(Color.white.opacity(0.2))
                
                MenuItem(title: "Delete", icon: "delete", color: .white, action: {
                    print("Delete tapped")
                    showMenu = false
                })
            }
            .frame(width: 236)
            .background(
                Color.white.opacity(0.5)
            )
            .cornerRadius(20)
        }
    }
}

#Preview {
    ShowSongMenu(showMenu: .constant(true))
}
