//
//  CartService.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

protocol CartService {
    func add(product: Product)
    func remove(productId: String)
    func update(productId: String, quantity: Int)
    func items() -> [CartItem]
    func summary() -> CartSummary
    func clear()
}
