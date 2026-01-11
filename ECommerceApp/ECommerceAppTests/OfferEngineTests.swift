//
//  OfferEngineTests.swift
//  ECommerceAppTests
//
//  Created by Jaynesh Patel on 10/01/26.
//

import XCTest
@testable import ECommerceApp

final class OfferEngineTests: XCTestCase {

    func testFlatDiscountOffer() {
        let engine = OfferEngine()
        let offer = FlatDiscountOffer(
            id: "flat50",
            title: "₹50 OFF",
            amount: 50
        )

        engine.apply(offer: offer)

        let discount = engine.discount(for: 300)
        XCTAssertEqual(discount, 50)
    }

    func testPercentageDiscountOffer() {
        let engine = OfferEngine()
        let offer = PercentageDiscountOffer(
            id: "perc10",
            title: "10% OFF",
            percentage: 10
        )

        engine.apply(offer: offer)

        let discount = engine.discount(for: 500)
        XCTAssertEqual(discount, 50)
    }

    func testOnlyOneOfferCanBeApplied() {
        let engine = OfferEngine()

        let offer1 = FlatDiscountOffer(
            id: "flat50",
            title: "₹50 OFF",
            amount: 50
        )

        let offer2 = PercentageDiscountOffer(
            id: "perc10",
            title: "10% OFF",
            percentage: 10
        )

        engine.apply(offer: offer1)
        engine.apply(offer: offer2) // ignored

        let discount = engine.discount(for: 500)
        XCTAssertEqual(discount, 50)
    }
}
