//
//  CustomTabBarView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 17.12.2024.
//
import SwiftUI

enum Tab: Int {
    case home = 0
    case library = 1
    case settings = 2
}

enum Icons: String {
    case homeSelected = "home-selected"
    case homeNotSelected = "home-not-selected"
    case librarySelected = "library-selected"
    case libraryNotSelected = "library-not-selected"
    case settingsSelected = "settings-selected"
    case settingsNotSelected = "settings-not-selected"
}

struct CustomTabBarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 32) {
                TabBarIcon(
                    iconName: selectedTab == Tab.home.rawValue ? Icons.homeSelected : Icons.homeNotSelected,
                    isSelected: selectedTab == Tab.home.rawValue
                ) {
                    selectedTab = Tab.home.rawValue
                }
                TabBarIcon(
                    iconName: selectedTab == Tab.library.rawValue ? Icons.librarySelected : Icons.libraryNotSelected,
                    isSelected: selectedTab == Tab.library.rawValue
                ) {
                    selectedTab = Tab.library.rawValue
                }
                TabBarIcon(
                    iconName: selectedTab == Tab.settings.rawValue ? Icons.settingsSelected : Icons.settingsNotSelected,
                    isSelected: selectedTab == Tab.settings.rawValue
                ) {
                    selectedTab = Tab.settings.rawValue
                }
            }
            .padding(.horizontal, 24)
            .frame(width: 208, height: 64)
            .background(Color.black.opacity(0.2))
            .cornerRadius(100, corners: [.allCorners])
        }
    }
}

struct TabBarIcon: View {
    let iconName: Icons
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(iconName.rawValue)
                .scaledToFit()
                .frame(width: 32, height: 32)
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    CustomTabBarView(selectedTab: .constant(0))
}
