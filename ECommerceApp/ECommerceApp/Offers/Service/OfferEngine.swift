//
//  OfferEngine.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

final class OfferEngine {

    private(set) var appliedOffer: Offer?

    func apply(offer: Offer) {
        guard appliedOffer == nil else { return }
        appliedOffer = offer

        NotificationCenter.default.post(name: .offerApplied, object: nil)
    }

    func removeOffer() {
        appliedOffer = nil
        NotificationCenter.default.post(name: .offerApplied, object: nil)
    }

    func discount(for subtotal: Double) -> Double {
        appliedOffer?.discountAmount(for: subtotal) ?? 0
    }
    
    func reset() {
        appliedOffer = nil
    }
}
