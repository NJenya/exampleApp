//
//  SettingsView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 16.12.2024.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsModel()
    @Binding var path: NavigationPath
    @Binding var hideTabBar: Bool

    var body: some View {
        ZStack {
            ScrollView{
                mainContent
            }
            .scrollDisabled(true)
            
            //                if viewModel.showModalAlertView {
            //                    modalAlertOverlay
            //                }
        }
        .background{
            Image(.settingsBg)
                .resizable()
                .ignoresSafeArea()
        }
        .onChange(
            of: UserDefaultsManager.shared.hasSubscription,
            perform: { newValue in
                viewModel.hasSubscription = newValue
            })
        .sheet(isPresented: $viewModel.showMailView) {
            MailView(recipient: "apps@it-incubator.eu")
        }
        .alert("Mail Not Set Up", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .fullScreenCover(isPresented: $viewModel.navigateToPremiumFromNavBar) {
            PremiumView(path: $path, isFromOnboarding: false) {
                viewModel.navigateToPremiumFromNavBar = false
            }        }
        .fullScreenCover(isPresented: $viewModel.navigateToPremiumModalAlertView) {
            PremiumView(path: $path, isFromOnboarding: false) {
                viewModel.navigateToPremiumModalAlertView = false
            }        }
        .fullScreenCover(isPresented: $viewModel.showPremiumView) {
            PremiumView(path: $path, isFromOnboarding: false) {
                viewModel.showPremiumView = false
            }        }
        
        .modalAlert(
            songsLeft: viewModel.songsLeft,
            isPresented: $viewModel.showModalAlertView,
            action: {
                viewModel.navigateToPremiumModalAlertView = true
                LoaderManager.shared.show()
            }
        )
        .onChange(of: viewModel.showModalAlertView) { isPresented in
            hideTabBar = isPresented
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 24) {
            AppNavigationBarView(
                songsLeft: $viewModel.songsLeft,
                titleName: "Settings",
                songsLeftAction: { viewModel.showModalAlertView.toggle()
                },
                onPremiumButtonPush: {
                    viewModel.navigateToPremiumFromNavBar = true
                    LoaderManager.shared.show()
                }
            )
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 11) }
            
            if !viewModel.hasSubscription {
                premiumBanner
            }
            settingsList
        }
    }
    
    // MARK: - Premium Banner
    private var premiumBanner: some View {
        ZStack {
            Image(.background)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .onTapGesture {
                    viewModel.showPremiumView = true
                    LoaderManager.shared.show()
                }
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Enjoy Premium Access")
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("Get unlimited song generations")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundStyle(.white)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 21))
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Settings List
    private var settingsList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.settings.indices, id: \.self) { index in
                let setting = viewModel.settings[index]
                SettingsCellView(imageName: setting.imageName, name: setting.name)
                    .onTapGesture { handleTap(index) }
            }
        }
        .padding(.horizontal, 16)
        .scrollDisabled(true)
    }
    
    // MARK: - Handle Setting Tap
    private func handleTap(_ index: Int) {
        switch index {
        case 0:
            viewModel.rateApp()
        case 1:
            if MFMailComposeViewController.canSendMail() {
                viewModel.mailData = viewModel.prepareSupportEmail()
                viewModel.showMailView = true
            } else {
                viewModel.alertMessage = "Please set up your email account to send emails."
                viewModel.showAlert = true
            }
        case 2:
            viewModel.openURL(viewModel.privacyPolicyURL)
        case 3:
            viewModel.openURL(viewModel.termsOfUseURL)
        case 4:
            viewModel.shareApp()
        default:
            break
        }
    }
}
