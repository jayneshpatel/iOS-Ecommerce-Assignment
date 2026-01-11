//
//  ScratchCardsViewModel.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

@MainActor
final class ScratchCardsViewModel {

    private let offerEngine: OfferEngine
    private(set) var cards: [ScratchCard] = []
    var isOfferApplied: Bool {
        offerEngine.appliedOffer != nil
    }

    init(offerEngine: OfferEngine) {
        self.offerEngine = offerEngine
        generateCards()
    }

    private func generateCards() {
        cards = [
            ScratchCard(
                id: "1",
                offer: FlatDiscountOffer(id: "flat50", title: "₹50 OFF", amount: 50),
                isScratched: false
            ),
            ScratchCard(
                id: "2",
                offer: PercentageDiscountOffer(id: "perc10", title: "10% OFF", percentage: 10),
                isScratched: false
            ),
            ScratchCard(
                id: "3",
                offer: NoRewardOffer(id: "none", title: "Better Luck Next Time"),
                isScratched: false
            )
        ]
    }

    func scratchCard(at index: Int) -> Bool {
        guard cards.indices.contains(index),
              !cards[index].isScratched,
              offerEngine.appliedOffer == nil
        else { return false }

        cards[index].isScratched = true
        offerEngine.apply(offer: cards[index].offer)
        return true
    }
}
