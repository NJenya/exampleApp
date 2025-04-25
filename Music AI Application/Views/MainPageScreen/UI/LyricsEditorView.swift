//
//  LyricsEditorView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 19.01.2025.
//

import SwiftUI

struct LyricsEditorView: View {
    @FocusState var isTextFieldFocused: Bool
    @EnvironmentObject private var model: MainPageModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if isTextFieldFocused {
                headerButtons
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                lyricsTextEditor
            }
            .padding(.bottom, 16)
            .background(Color.white.opacity(0.15))
            .cornerRadius(20)
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Subviews

private extension LyricsEditorView {
    
    var headerSection: some View {
        HStack {
            Text("Lyrics")
                .font(.dmSans(size: 18, weight: .regular))
                .foregroundColor(.white)
                .padding(.leading, 20)
                .padding(.top, 16)
            
            Spacer()
            
            actionButtons
        }
    }
    
    var headerButtons: some View {
        HStack {
            Button("Cancel") {
                model.draftLyrics = model.savedLyrics
                isTextFieldFocused = false
                model.isEditingLyrics = false
            }
            .foregroundColor(.white)
            .frame(width: 92, height: 32)
            .background(Color.white.opacity(0.2))
            .cornerRadius(16)
            
            Spacer()
            
            Button("Save") {
                model.savedLyrics = model.draftLyrics
                isTextFieldFocused = false
                model.isEditingLyrics = false
            }
            .foregroundColor(.white)
            .frame(width: 92, height: 32)
            .background(Color.white.opacity(0.2))
            .cornerRadius(16)
        }
    }
    
    var actionButtons: some View {
        HStack {
            Button(action: {
                getRandomLyrics()
            }) {
                Image(systemName: "dice.fill")
                    .font(.title2)
                    .foregroundColor(Color(red: 204/255, green: 255/255, blue: 0/255, opacity: 1.0))
            }
            .padding(.top, 16)
            .padding(.trailing, isTextFieldFocused ? 12 : 16)
            
            if model.draftLyrics != "" && model.isEditingLyrics{
                Button {
                    model.draftLyrics = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 204/255, green: 255/255, blue: 0/255, opacity: 1.0))
                }
                .padding(.top, 16)
                .padding(.trailing, 19)
            }
        }
    }
    
    var lyricsTextEditor: some View {
        TextEditor(text: $model.draftLyrics)
            .font(.dmSans(size: 16, weight: .regular))
            .foregroundColor(.white)
            .focused($isTextFieldFocused)
            .onChange(of: isTextFieldFocused) { newValue in
                model.isEditingLyrics = newValue
            }
            .onAppear{
                self.isTextFieldFocused = model.isEditingLyrics
                if model.draftLyrics.isEmpty {
                    model.draftLyrics = model.savedLyrics
                }
            }
            .scrollContentBackground(.hidden)
            .lineSpacing(max(0, 20.83 - UIFont.systemFont(ofSize: 16).lineHeight))
            .background(Color.clear)
            .scrollDisabled(!isTextFieldFocused)
            .padding(.horizontal, 16)
            .frame(height: isTextFieldFocused ? 350 : 224)
            .overlay(alignment: .topLeading) {
                if model.draftLyrics.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isTextFieldFocused {
                    Text("Write your own lyrics...")
                        .font(.dmSans(size: 16, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding(.top, 8)
                        .padding(.leading, 20)
                }
            }
    }
    
    func getRandomLyrics() {
        let songLyrics = [
            """
            Verse 1:
            Walking down the empty streets,
            Lost in melodies so sweet.
            The night is young, the stars align,
            Dreaming of a love divine.
            
            Chorus:
            Take me higher, lift me up,
            Let the music fill my cup.
            Heartbeats racing to the sound,
            In this rhythm, we are found.
            """,
            
            """
            Verse 1:
            Raindrops falling on my skin,
            Washing out where I've been.
            Thunder whispers, skies ignite,
            Dancing through the storm tonight.
            
            Chorus:
            Let it rain, let it pour,
            I'll be stronger than before.
            Through the clouds, I'll rise again,
            Chasing dreams beyond the rain.
            """
        ]
        LoaderManager.shared.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            LoaderManager.shared.hide()
            isTextFieldFocused = true
            model.draftLyrics = songLyrics.randomElement() ?? "Could not fetch Random Lyrics"
        }
    }
}
