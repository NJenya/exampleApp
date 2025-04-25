//
//  PremiumAccess.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 01.03.2025.
//

import Foundation

struct Access {
    let place: String
    let trial: String
    let cost: String
    let period: String
}

struct ProductDetails: Codable {
    let attributes: ProductAttributes
}

struct ProductAttributes: Codable {
    let offers: [Offer]
}

struct Offer: Codable {
    let recurringSubscriptionPeriod: String
    let discounts: [Discount]?
}

struct Discount: Codable {
    let modeType: String
    let numOfPeriods: Int
    let recurringSubscriptionPeriod: String
}
