//
//  CartViewModel.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

@MainActor
final class CartViewModel {

    private let cartService: CartService

    init(cartService: CartService) {
        self.cartService = cartService
    }

    var items: [CartItem] {
        cartService.items()
    }

    var summary: CartSummary {
        cartService.summary()
    }

    func numberOfItems() -> Int {
        items.count
    }

    func item(at index: Int) -> CartItem {
        items[index]
    }

    func updateQuantity(productId: String, quantity: Int) {
        cartService.update(productId: productId, quantity: quantity)
    }

    func removeItem(productId: String) {
        cartService.remove(productId: productId)
    }
}
