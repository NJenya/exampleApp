//
//  AppNavigationBarView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 20.01.2025.
//
import SwiftUI

struct AppNavigationBarView: View {
    @Binding var songsLeft: Int
    let titleName: String
    let songsLeftAction: () -> Void
    let onPremiumButtonPush: () -> Void
    private let hasSubscription = UserDefaultsManager.shared.hasSubscription
    
    var body: some View {
        HStack (spacing: 0){
            Text(titleName)
                .font(.dmSans(size: 28, weight: .medium))
                .padding(.leading, 32)
                .foregroundColor(Color.white)
            Spacer()
            if !hasSubscription {
                BadgeSongsLeft(songsLeft: songsLeft, action: songsLeftAction)
                    .padding(.trailing, 8)
                IconButton(iconName: "crown-icon", action: {
                    onPremiumButtonPush()
                })
            }else{
                unlimitedBadge(action: {})
            }
        }
        .padding(.trailing, 16)
    }
}

struct BadgeSongsLeft: View {
    var songsLeft: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            HStack(alignment: .center, spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 32, height: 32)
                        .padding(4)
                    
                    Text(String(songsLeft))
                        .foregroundColor(Color(red: 204/255, green: 255/255, blue: 0/255, opacity: 1.0))
                        .font(.dmSans(size: 16, weight: .medium))
                }
                
                Image("badgeSongLeft-Icon")
                    .padding(.vertical, 9.5)
                    .padding(.trailing, 12)
            }
            .frame(width: 68, height: 40)
            .background(
                Color.white.opacity(0.1)
                    .blur(radius: 10)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct unlimitedBadge: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            HStack(alignment: .center, spacing: 0) {
                Image("unlimited-icon")
                    .padding(.vertical, 4)
                    .padding(.leading, 4)
                    
                Text("PRO")
                    .foregroundColor(.white)
                    .font(.dmSans(size: 10, weight: .medium))
                    .padding(.leading, 8)
                    .padding(.trailing, 12)
            
            }
            .frame(width: 76, height: 40)
            .background(
                Color.white.opacity(0.1)
                    .blur(radius: 10)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct IconButton: View {
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(iconName)
                .frame(width: 28, height: 21)
                .padding(.vertical, 9.5)
                .padding(.horizontal, 6)
                .clipShape(Circle())
        }
        .background(Color.white.opacity(0.1))
        .clipShape(Circle())
        .frame(width: 40, height: 40)
    }
}

#Preview {
    VStack {
        AppNavigationBarView(songsLeft: .constant(5), titleName: "AI Music", songsLeftAction: {}, onPremiumButtonPush: {})
        Spacer()
    }
    .background(
        Image("backgroundImage")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    )
}
