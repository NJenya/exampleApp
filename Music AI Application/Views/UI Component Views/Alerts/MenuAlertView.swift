//
//  MenuAlertView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 18.03.2025.
//

import SwiftUI

enum AlertType {
    case rename
    case delete
    case noLyricsGenerate
    case generatingMusic
    case cancelGeneration
    case takingLongerCancelGeneration
}

struct MenuAlertView: View {
    
    let alertType: AlertType
    let model: LibrarySongModel?
    @State private var newSongName: String
    
    @Namespace private var namespace
    
    @Binding var isPresented: Bool
    @State private var titleKey: LocalizedStringKey
    @State private var actionTextKey: LocalizedStringKey
    
    private var action: (String) -> ()
    
    init(
        alertType: AlertType,
        titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        actionTextKey: LocalizedStringKey,
        action: @escaping (String) -> (),
        model: LibrarySongModel?
    ) {
        self.alertType = alertType
        self.action = action
        self.model = model
        _titleKey = State(initialValue: titleKey)
        _actionTextKey = State(initialValue: actionTextKey)
        _isPresented = isPresented
        _newSongName = State(initialValue: model?.songTitle ?? "")
    }
    
    var body: some View {
        VStack (spacing: 16) {
            VStack (spacing: alertType == .rename ? 12 : 4 ){
                if (alertType == .generatingMusic) {
                    Image("loader")
                        .padding(.top, 4)
                }
                Text(titleKey)
                    .foregroundColor(.white)
                    .font(.dmSans(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                
                if (alertType == .rename){
//                    TextField("Write a title", text: $newSongName)
//                        .font(.dmSans(size: 16, weight: .medium))
//                        .padding(.leading, 20)
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .background(.black.opacity(0.2))
//                        .cornerRadius(100)
                    HStack {
                        TextField("Write a title", text: $newSongName)
                            .font(.dmSans(size: 16, weight: .medium))
                            .padding(.leading, 20)
                            .padding(.vertical, 10)
                        
                        if !newSongName.isEmpty {
                            Button(action: {
                                newSongName = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .padding(.trailing, 12)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(.black.opacity(0.2))
                    .cornerRadius(100)
                } else if (alertType == .delete) {
                    Text("Are you sure you want to delete this song? It will be permanently removed from your library and can't be recovered.")
                        .font(.dmSans(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }else if (alertType == .noLyricsGenerate){
                    Text("Are you sure you want to generate the song without lyrics? The melody will be created without any words.")
                        .font(.dmSans(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }else {
                    Text("You can find it in the Library.")
                        .font(.dmSans(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            //            Spacer()
            VStack (spacing: 8) {
                Button(action: {
                    action(newSongName)
                    dismiss()
                }) {
                    Text(actionTextKey)
                        .font(.dmSans(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 204 / 255, green: 255 / 255, blue: 0 / 255))
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(.white.opacity(0.1))
                .cornerRadius(22)
                .disabled(newSongName.isEmpty && alertType == .rename)
                .opacity(newSongName.isEmpty && alertType == .rename ? 0.5 : 1)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.dmSans(size: 16, weight: .regular))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(.white.opacity(0.1))
                .cornerRadius(22)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 270, alignment: .center)
        .background(.white.opacity(0.2))
        .background(.thickMaterial)
        .cornerRadius(20)
    }
    
    func dismiss() {
        isPresented = false
    }
}

