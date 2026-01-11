//
//  NoRewardOffer.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

struct NoRewardOffer: Offer {
    let id: String
    let title: String

    func discountAmount(for subtotal: Double) -> Double {
        0
    }
}
