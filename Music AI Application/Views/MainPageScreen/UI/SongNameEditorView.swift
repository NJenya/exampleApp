//
//  SongEditorView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 18.01.2025.
//


import SwiftUI

struct SongNameEditorView: View {
    @Binding var songName: String 
    @Binding var isSongNameEditing: Bool
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if songName.isEmpty {
                    Text("Write your own title")
                        .font(.dmSans(size: 18, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding(.leading, 20)
                }
                
                TextField("", text: $songName)
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .disabled(!isSongNameEditing)
                    .focused($isTextFieldFocused)
                    .onChange(of: isSongNameEditing) { newValue in
                        if newValue {
                            isTextFieldFocused = true
                        } else {
                            isTextFieldFocused = false
                        }
                    }
            }
            .frame(height: 44)
            
            Spacer()
            
            Button(action: {
                isSongNameEditing.toggle()
            }) {
                Image(systemName: isSongNameEditing ? "xmark.circle.fill" : "pencil")
                    .foregroundColor(Color.white.opacity(0.5))
            }
            .padding(.trailing, 20)
        }
        .frame( height: 44)
        .background(Color.white.opacity(0.15))
        .cornerRadius(22)
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 12)
    }
}

