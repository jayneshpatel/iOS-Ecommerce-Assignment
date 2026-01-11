//
//  PaymentViewModel.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

@MainActor
final class PaymentViewModel {

    private let paymentService: PaymentService
    private let amount: Double

    init(paymentService: PaymentService, amount: Double) {
        self.paymentService = paymentService
        self.amount = amount
    }

    var payableAmountText: String {
        "Pay ₹\(Int(amount))"
    }

    var payableAmount: Double {
        amount
    }

    func pay(using method: PaymentMethod) async -> PaymentResult {
        await paymentService.pay(amount: amount, method: method)
    }
}
