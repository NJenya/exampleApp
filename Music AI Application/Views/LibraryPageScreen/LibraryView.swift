//
//  LibraryView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 16.12.2024.
//

import SwiftUI
import CoreData

struct LibraryView: View {
    @Binding var hideTabBar: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: LibraryViewModel
    @AppStorage("songsLeft") var songsLeft: Int = UserDefaultsManager.shared.songsLeft
    
    init(hideTabBar: Binding<Bool>,
         viewModel: LibraryViewModel,
         path: Binding<NavigationPath>) {
        self._hideTabBar = hideTabBar
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
        ZStack{
            VStack {
                mainContentView
            }
            .ignoresSafeArea(edges: .bottom)
            .customAlert(
                "Rename this Song",
                isPresented: $viewModel.showRenameAlert,
                actionText: "Save",
                action: { name in
                    if name != "" {
                        viewModel.renameSong(model: viewModel.selectedSong ?? nil, newName: name)
                    }
                },
                alertType: .rename,
                model: viewModel.selectedSong ?? nil
            )
            
            .customAlert(
                "Delete this Song?",
                isPresented: $viewModel.showDeleteAlert,
                actionText: "Delete",
                action: { _ in
                    viewModel.deleteSong(model: viewModel.selectedSong ?? nil)
                },
                alertType: .delete,
                model: viewModel.selectedSong ?? nil
            )
            
            if viewModel.songViewModels.contains(where: { $0.isLoading }) {
                Button(action: {
                    viewModel.cancelGeneration()
                }) {
                    HStack(alignment: .center) {
                        Text("Cancel Generation")
                            .foregroundColor(.white)
                            .font(.dmSans(size: 16, weight: .regular))
                    }
                    .frame(width: 230, height: 44)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(22)
                }
                .padding(.bottom, 90)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .background(
            backgroundView
        )
        
        .navigationDestination(for: LibraryScreens.self, destination: { screen in
            if screen == .songPage {
                if !viewModel.songViewModels.isEmpty {
                    SongPageView(
                        model: viewModel.songViewModels[viewModel.selectedSongIndex],
                        onDismiss: {
                            path.removeLast()
                            hideTabBar = false
                        })
                    .navigationBarBackButtonHidden()
                    .onAppear(){
                        hideTabBar = true
                    }
                } else {
                    ProgressView()
                }
            }
        })
        
        .fullScreenCover(isPresented: $viewModel.navigateToPremiumFromNavBar) {
            PremiumView(path: $path, isFromOnboarding: false) {
                viewModel.navigateToPremiumFromNavBar = false
                LoaderManager.shared.show()
            }
        }
        .fullScreenCover(isPresented: $viewModel.navigateToPremiumFromModalAlertView) {
            PremiumView(path: $path, isFromOnboarding: false) {
                viewModel.navigateToPremiumFromModalAlertView = false
            }
        }
        
        .modalAlert(
            songsLeft: songsLeft,
            isPresented: $viewModel.showModalAlertView,
            action: {
                viewModel.navigateToPremiumFromModalAlertView = true
                LoaderManager.shared.show()
            }
        )
        .onChange(of: viewModel.showModalAlertView) { isPresented in
            hideTabBar = isPresented
        }
    }
    // MARK: - Background View
    private var backgroundView: some View {
        Image("library_bg")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    // MARK: - Main View
    
    private var mainContentView: some View {
        ZStack {
            VStack {
                AppNavigationBarView(
                    songsLeft: $songsLeft,
                    titleName: "Library",
                    songsLeftAction: {
                        viewModel.showModalAlertView = true
                    },
                    onPremiumButtonPush: {
                        viewModel.navigateToPremiumFromNavBar = true
                        LoaderManager.shared.show()
                    })
                .safeAreaInset(edge: .top) { Color.clear.frame(height: 11) }
                
                if viewModel.songViewModels.isEmpty {
                    LibraryEmptyView()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.songViewModels.enumerated()), id: \.element.id) {
                                index,
                                model in
                                LibrarySongComponentView(
                                    songModel: model,
                                    playAction: {
                                        path.append(LibraryScreens.songPage)
                                        viewModel.selectedSongIndex = index
                                    },
                                    menuAction: {
                                        viewModel.selectedSong = model
                                    },
                                    selectedOption: $viewModel.selectedOption
                                )
                                .onChange(of: viewModel.selectedOption, perform: { newValue in
                                    viewModel.toggleMenuAlert(newValue)
                                })
                            }
                        }
                        .padding(.horizontal, 16)
                        .ignoresSafeArea(.container, edges: .bottom)
                    }
                    Spacer()
                }
            }
        }
    }
    // MARK: - Cancel Button View

//    private var cancelGenerationButton: some View {
//          GeometryReader { geometry in
//              Button(action: {
//                  viewModel.cancelGeneration()
//              }) {
//                  HStack {
//                      Text("Cancel Generation")
//                          .foregroundColor(.white)
//                      Spacer()
//                      Image(systemName: "xmark")
//                          .foregroundColor(.white)
//                  }
//                  .padding(.horizontal, 20)
//                  .frame(width: 230, height: 44)
//                  .background(Color.red)
//                  .cornerRadius(22)
//              }
//              .position(
//                  x: 73 + 230 / 2,
//                  y: geometry.size.height - 90 - 44 / 2
//              )
//          }
//          .ignoresSafeArea()
//      }
}

