//
//  PurchaseManager.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 01.03.2025.
//

import StoreKit

final class InAppPurchaseManager {
    static let shared = InAppPurchaseManager()
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = Set()
    
    init() {
        Task { [weak self] in
            await self?.listenForTransactions()
        }
    }
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func updatePurchasedProducts() async {
        let transactions = await withTaskGroup(of: String?.self) { group in
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result, transaction.revocationDate == nil else { continue }
                group.addTask { transaction.productID }
            }
            
            return await group.reduce(into: Set<String>()) { if let id = $1 { $0.insert(id) } }
        }

        await MainActor.run {
            purchasedProductIDs = transactions
            UserDefaultsManager.shared.hasSubscription = !purchasedProductIDs.isEmpty
        }
    }

    private func handleVerifiedTransaction(_ transaction: Transaction) async {
        await MainActor.run {
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        Task {
            await transaction.finish()
        }
    }
    
    func listenForTransactions() async {
        for await result in Transaction.updates {
            switch result {
            case .verified(let transaction):
                await handleTransaction(transaction)
            case .unverified(let transaction, _):
                await transaction.finish()
            }
        }
    }
    
    private func handleTransaction(_ transaction: Transaction) async {
        await handleVerifiedTransaction(transaction)
        await MainActor.run(){
            UserDefaultsManager.shared.hasSubscription = self.hasUnlockedPro
        }
    }
    
    func fetchProducts(_ identifiers: [String]) async -> [Product] {
        do {
            let products = try await Product.products(for: identifiers)
            await MainActor.run {
                self.products = products
            }
        } catch {
            print("Failed to load products: \(error)")
        }
        return products
    }
    
    func purchase(_ productID: String) async -> Bool {
        DispatchQueue.main.async {
            LoaderManager.shared.show()
        }
        defer {
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
            }
        }
        guard let product = products.filter({ $0.id == productID }).first else {
            return false
        }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                return try await handlePurchaseSuccess(verification)
            case .pending:
                handlePurchasePending()
                return false
            default:
                break
            }
        } catch {
            return false
        }
        return false
    }
    
    private func handlePurchaseSuccess(_ verification: VerificationResult<Transaction>) async throws -> Bool {
        let transaction = try checkVerified(verification)
        await updatePurchasedProducts()
        await transaction.finish()
        return true
    }
    
    private func handlePurchasePending() {
//        DispatchQueue.main.async {
//            self.showErrorAlert("Purchase is Pending")
//        }
        print("Purchase Pending")
    }
    
    private func checkVerified(_ verification: VerificationResult<Transaction>) throws -> Transaction {
        switch verification {
        case .verified(let transaction):
            return transaction
        case .unverified:
            throw NSError(domain: "YourErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "R.string.localizable.verify_transaction_failed()"])
        }
    }
    
    func restorePurchases() async -> Bool {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            return true
        } catch {
            print("Restore purchase failed: \(error.localizedDescription)")
            return false
        }
    }
}
