//
//  LoaderAnimationView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 22.03.2025.
//

import SwiftUI


struct LoaderView: View {
    @State private var moveRight = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 56, height: 32)
                .foregroundColor(.clear)

            HStack(spacing: 0) {
                Circle()
                    .fill(Color(red: 204/255, green: 255/255, blue: 0/255).opacity(1))
                    .frame(width: 32, height: 32)
                    .offset(x: moveRight ? 26 : 6)
                    .zIndex(0)

                Circle()
                    .fill(.white.opacity(0.3)) // #FFFFFF33
                    .frame(width: 32, height: 32)
                    .offset(x: moveRight ? -24 : -6)
                    .blur(radius: 0.4)
                    .zIndex(1)
            }
            .frame(width: 56, height: 32)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                withAnimation(.linear(duration: 0.8)) {
                    moveRight.toggle()
                }
            }
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
            .background(.black)
    }
}
