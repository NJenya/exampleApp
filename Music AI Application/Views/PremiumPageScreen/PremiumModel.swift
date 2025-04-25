//
//  PremiumModel.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 01.03.2025.
//
import Foundation
import StoreKit

@MainActor
final class PremiumModel: ObservableObject {
    @Published var subscriptions: [String]
    @Published var accesses: [Subscription]
    @Published var showNetworkAlert = false
    @Published var alertMessage = ""
    @Published var navigateToCoordinator = false
    @Published var isLoaded: Bool = false
    @Published var selectedSubscription: UUID?
    
    var selectedAccess: Int
    
    init(fromWelcome: Bool = !UserDefaultsManager.shared.isWelcomeTourCompleted) {
        let tempSubscribe: [String]
        self.subscriptions = []
        self.accesses = []
        self.selectedAccess = 0
        
        tempSubscribe = ["com.musicai.1we", "com.musicai.1mo", "com.musicai.1ye"]
        subscriptions = tempSubscribe
        
        if (InAppPurchaseManager.shared.products.isEmpty){
            Task {
                await fetchAndSetupAccesses()
            }
        }else{
            setupSubscriptionCell(with: InAppPurchaseManager.shared.products)
        }
    }
    
    func fetchAndSetupAccesses() async {
        let fetchedProducts = await InAppPurchaseManager.shared.fetchProducts(subscriptions)
        await MainActor.run {
            setupSubscriptionCell(with: fetchedProducts)
        }
    }
    
    func setupSubscriptionCell(with products: [Product]) {
        let relevantSubscriptions = !UserDefaultsManager.shared.isWelcomeTourCompleted
        ? [UserDefaultsManager.shared.onboarding_first_subscription,
           UserDefaultsManager.shared.onboarding_second_subscription]
        : [UserDefaultsManager.shared.settings_first_subscription,
           UserDefaultsManager.shared.settings_second_subscription]

        self.accesses = products
            .filter { relevantSubscriptions.contains($0.id) }
            .map { product in
                let period = parseProductDetails(from: product.id)
                return Subscription(
                    subscriptionId: product.id,
                    title: product.displayName,
                    subtitle: period == "year" ? "\(product.displayPrice)" : "",
                    priceString: product.displayPrice,
                    price: product.price,
                    pricePeriod: period
                )
            }
            .sorted(by: {$0.price > $1.price})
        selectedSubscription = accesses.first?.id
        isLoaded = true
    }
    
    func purchase() async -> Bool {
        LoaderManager.shared.show()
        defer {
            LoaderManager.shared.hide()
        }
        let index = selectedAccess
        let subscriptionID = accesses[index].subscriptionId
        return await InAppPurchaseManager.shared.purchase(subscriptionID)
    }
    
    func restorePurchases() async -> Bool {
        LoaderManager.shared.show()
        defer {
            LoaderManager.shared.hide()
        }
        return await InAppPurchaseManager.shared.restorePurchases()
    }
}

extension PremiumModel {
    func parseProductDetails(from productID: String) -> (String) {
        return if productID.contains("we") {"week"}
        else if productID.contains("mo") {"month"}
        else if productID.contains("ye") {"year"}
        else { "year" }
    }
}

struct Subscription: Identifiable, Equatable {
    let subscriptionId: String
    let id = UUID()
    let title: String
    let subtitle: String
    let priceString: String
    let price: Decimal
    let pricePeriod: String
}
