//
//  FlatDiscountOffer.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

struct FlatDiscountOffer: Offer {
    let id: String
    let title: String
    let amount: Double

    func discountAmount(for subtotal: Double) -> Double {
        min(amount, subtotal)
    }
}
