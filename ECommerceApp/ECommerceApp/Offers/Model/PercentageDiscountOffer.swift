//
//  PercentageDiscountOffer.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

struct PercentageDiscountOffer: Offer {
    let id: String
    let title: String
    let percentage: Double

    func discountAmount(for subtotal: Double) -> Double {
        subtotal * (percentage / 100)
    }
}
