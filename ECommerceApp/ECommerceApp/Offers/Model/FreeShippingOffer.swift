//
//  FreeShippingOffer.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

struct FreeShippingOffer: Offer {
    let id: String
    let title: String

    func discountAmount(for subtotal: Double) -> Double {
        50 // assume flat shipping fee
    }
}
