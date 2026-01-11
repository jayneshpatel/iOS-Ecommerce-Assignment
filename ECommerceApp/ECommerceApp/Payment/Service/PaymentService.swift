//
//  PaymentService.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

protocol PaymentService {
    func pay(amount: Double,
             method: PaymentMethod) async -> PaymentResult
}
