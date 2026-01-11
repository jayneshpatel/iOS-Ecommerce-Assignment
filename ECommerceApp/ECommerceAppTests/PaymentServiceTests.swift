//
//  PaymentServiceTests.swift
//  ECommerceAppTests
//
//  Created by Jaynesh Patel on 10/01/26.
//

import XCTest
@testable import ECommerceApp

final class PaymentServiceTests: XCTestCase {

    func testPaymentReturnsSuccess() async {
        let service = DummyPaymentService()

        let result = await service.pay(
            amount: 100,
            method: .card
        )

        switch result {
        case .success(let transactionId):
            XCTAssertFalse(transactionId.isEmpty)

        default:
            XCTFail("Payment should succeed in DummyPaymentService")
        }
    }
}
