//
//  PremiumView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 01.03.2025.
//

import SwiftUI
import Network

struct PremiumView: View {
    @Binding var path: NavigationPath
    let isFromOnboarding: Bool
    @StateObject private var premiumModel = PremiumModel()
    @Environment(\.dismiss) var dismiss
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            if premiumModel.isLoaded {
                Image(.premiumBg)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack (spacing: 8) {
                        headerView
                        premiumBenefits
                    }
                    Spacer()
                    VStack(spacing: 16) {
                        
                        subscriptionOptions
                        actionButton
                        footerView
                    }
                }
                .padding()
            }else{
                Image(.premiumBg)
                    .resizable()
                    .ignoresSafeArea()
            }
        }
        .onAppear(){
            Task {
                await premiumModel.fetchAndSetupAccesses()
                LoaderManager.shared.hide()
            }
        }
        .alert("Network Error", isPresented: $premiumModel.showNetworkAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(premiumModel.alertMessage)
        }
    }
}

// MARK: - Subviews
extension PremiumView {
    private var headerView: some View {
        ZStack {
            HStack {
                Button(action: dismissAction) {
                    Image(.closeIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Spacer()
                Button(action: {
                    Task {
                        let success = await premiumModel.restorePurchases()
                        if success {
                            dismissAction()
                        }
                    }
                }) {
                    Text("Restore").font(.dmSans(size: 16, weight: .regular))
                }
            }
            Image(.badgePromo)
                .resizable()
                .frame(width: 56, height: 56)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
    private var premiumBenefits: some View {
        VStack(spacing: 8) {
            Text("Get Premium")
                .font(.dmSans(size: 40, weight: .bold))
                .foregroundColor(.white)
            HStack(spacing: 10) {
                VStack(spacing: 6) {
                    Image(._infinityIcon)
                    Image(.starIcon)
                    Image(.arrowIcon)
                }
                VStack(alignment: .leading) {
                    Text("Unlimited Generations")
                    Text("Access to All Music Styles")
                    Text("Download Any Song")
                }
            }
            .font(.headline)
            .foregroundColor(.white)
        }
        .padding(.top, 6)
    }
    
    private var subscriptionOptions: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
            ForEach(Array(premiumModel.accesses.enumerated()), id: \.element.id) { index, subscription in
                subscriptionCard(for: subscription, index: index)
            }
            
        }
    }
    
    private func subscriptionCard(for subscription: Subscription, index: Int) -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(premiumModel.selectedSubscription == subscription.id ? 0.3 : 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(premiumModel.selectedSubscription == subscription.id ? Color.white : Color.clear, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.3), radius: premiumModel.selectedSubscription == subscription.id ? 8 : 0)
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(getTitle(title: subscription.title))
                            .font(.dmSans(size: 18, weight: .bold))
                        if !subscription.subtitle.isEmpty {
                            Text("Just ") +
                            Text(subscription.subtitle)
                                .bold(UserDefaultsManager.shared.reviewPaywallIsShown) +
                            Text(" per year")
                                .font(.dmSans(size: 16, weight: .regular))
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(
                            getPrice(
                                period: subscription.pricePeriod,
                                priceString: subscription.priceString,
                                price: subscription.price
                            )
                        )
                        .font(.dmSans(size: 16, weight: UserDefaultsManager.shared.reviewPaywallIsShown ? .bold : .regular))
                        Text("per week")
                            .font(.dmSans(size: 16, weight: .regular))
                    }
                }
            }
            .padding(20)
            .foregroundColor(.white)
            
            if subscription.title.lowercased().contains("year") {
                bestValueBadge
            }
        }
        .frame(height: 80)
        .onTapGesture {
            withAnimation {
                premiumModel.selectedAccess = index
                premiumModel.selectedSubscription = premiumModel.accesses[index].id
            }
        }
    }
    
    private var bestValueBadge: some View {
        Text("Best Value")
            .font(.dmSans(size: 12, weight: .bold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(red: 0.80, green: 1.00, blue: 0.00))
            .foregroundColor(.black)
            .clipShape(Capsule())
            .offset(y: -10)
    }
    
    private var actionButton: some View {
        Button(action: {
            handlePurchase()
        }) {
            Text("Continue")
                .font(.dmSans(size: 18, weight: .bold))
                .foregroundColor(Color(red: 48/255, green: 1/255, blue: 76/255, opacity: 1))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(25)
        }
        .frame(height: 56)
    }
    
    private var footerView: some View {
        VStack(spacing: 8) {
            HStack {
                Image(.safetyIcon)
                Text("CANCEL ANYTIME").font(.dmSans(size: 12, weight: .medium))
            }
            HStack {
                Link("Terms of Use", destination: URL(string: "https://it-incubator.eu/en/terms-of-use")!)
                    .underline()
                Text("·")
                Link("Privacy Policy", destination: URL(string: "https://it-incubator.eu/en/privacy-policy")!)
                    .underline()
            }
            .font(.dmSans(size: 12))
        }
        .foregroundColor(.white)
    }
    
    private func dismissAction() {
        if isFromOnboarding {
            UserDefaultsManager.shared.isWelcomeTourCompleted = true
            path = NavigationPath()
            path.append(MainScreens.tabbar)
        } else {
            dismiss()
        }
    }
    
    private func handlePurchase() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    Task {
                        let success = await performPurchase()
                        if success {
                            dismissAction()
                        }
                    }
                } else {
                    premiumModel.showNetworkAlert = true
                    premiumModel.alertMessage = "No Internet Connection! Please check your connection"
                }
                monitor.cancel()
            }
        }
        monitor.start(queue: DispatchQueue(label: "Monitor"))
    }
    
    private func performPurchase() async -> Bool {
        return await premiumModel.purchase()
    }
    
    private func getPrice(period: String, priceString: String, price: Decimal) -> String {
        let adjustedPrice: Decimal
        
        switch period {
        case "week":
            adjustedPrice = price
        case "month":
            adjustedPrice = price / 4.29
        case "year":
            adjustedPrice = price / 52.14
        default:
            adjustedPrice = price
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        if let currencySymbol = formatter.currencySymbol {
            return "\(formatter.string(from: adjustedPrice as NSDecimalNumber) ?? "N/A")"
        } else {
            return formatter.string(from: adjustedPrice as NSDecimalNumber) ?? "N/A"
        }
    }
    
    private func getTitle(title: String) -> String{
        if title.lowercased().contains("year") {
            if UserDefaultsManager.shared.reviewPaywallIsShown {
                return "Annual Plan"
            }else{
                return "ANNUAL PLAN"
            }
        }else if title.lowercased().contains("month") {
            if UserDefaultsManager.shared.reviewPaywallIsShown {
                return "Monthly Plan"
            }else{
                return "MONTHLY PLAN"
            }
        }else {
            if UserDefaultsManager.shared.reviewPaywallIsShown {
                return "Weekly Plan"
            }else{
                return "WEEKLY PLAN"
            }
        }
    }
}

//#Preview {
//    PremiumView(isFromOnboarding: true)
//}
