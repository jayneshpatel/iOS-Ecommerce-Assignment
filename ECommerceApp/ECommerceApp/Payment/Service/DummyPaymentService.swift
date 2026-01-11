//
//  DummyPaymentService.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

final class DummyPaymentService: PaymentService {

    func pay(amount: Double,
             method: PaymentMethod) async -> PaymentResult {

        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        let outcomes: [PaymentResult] = [
            .success(transactionId: UUID().uuidString),
            .failure,
            .timeout
        ]

        return outcomes.randomElement()!
    }
}
