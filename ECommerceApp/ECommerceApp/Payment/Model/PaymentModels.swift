//
//  PaymentModels.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

enum PaymentMethod: String, CaseIterable {
    case card = "Card"
    case upi = "UPI"
    case wallet = "Wallet"
}

enum PaymentResult {
    case success(transactionId: String)
    case failure
    case timeout
}
