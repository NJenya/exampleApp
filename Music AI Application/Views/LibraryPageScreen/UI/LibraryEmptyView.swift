//
//  LibraryEmptyView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 27.01.2025.
//

import SwiftUI

struct LibraryEmptyView: View {
    var body: some View {
        Image("library_empty")
            .padding(.top, 130)
            .padding(.horizontal, 52)
        Text("Create your first song,\nand it will appear here!")
            .foregroundColor(.white)
            .font(.dmSans(size: 18, weight: .regular))
            .padding(.top, 36)
    }
}
