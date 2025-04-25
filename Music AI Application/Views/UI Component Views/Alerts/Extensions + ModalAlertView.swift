//
//  Extensions + ModalAlertView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 19.03.2025.
//

import Foundation
import SwiftUI

//extension View {
//    /// Presents an alert with a message when a given condition is true, using a localized string key for a title.
//    /// - Parameters:
//    ///   - titleKey: The key for the localized string that describes the title of the alert.
//    ///   - isPresented: A binding to a Boolean value that determines whether to present the alert.
//    ///   - data: An optional binding of generic type T value, this data will populate the fields of an alert that will be displayed to the user.
//    ///   - actionText: The key for the localized string that describes the text of alert's action button.
//    ///   - action: The alert’s action given the currently available data.
//    ///   - message: A ViewBuilder returning the message for the alert given the currently available data.
//    func modalAlert (
//        songsLeft: Int,
//        isPresented: Binding<Bool>,
//        action: @escaping () -> ()
//    ) -> some View {
//        fullScreenCover(isPresented: isPresented) {
//            Spacer()
//            ModalAlertView(
//                songsLeft: songsLeft,
//                onGetPremium: action,
//                isPresented: isPresented
//            )
//            .background(DarkBackgroundForAlerts())
//        }
////        .transaction { transaction in
////            transaction.disablesAnimations = true
////        }
//    }
//}
extension View {
    func modalAlert(
        songsLeft: Int,
        isPresented: Binding<Bool>,
        action: @escaping () -> ()
    ) -> some View {
        self.overlay(
            Group {
                if isPresented.wrappedValue {
                    ZStack {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture { }

                        VStack {
                            Spacer()

                            ModalAlertView(
                                songsLeft: songsLeft,
                                onGetPremium: action,
                                isPresented: isPresented
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 16)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isPresented.wrappedValue)
                        }
                    }
                    .ignoresSafeArea() 
                }
            }
        )
    }
}
