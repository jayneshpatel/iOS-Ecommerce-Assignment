//
//  CartServiceImpl.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

final class CartServiceImpl: CartService {

    private var cartItems: [CartItem] = []
    private let offerEngine: OfferEngine

    init(offerEngine: OfferEngine) {
        self.offerEngine = offerEngine
    }

    func add(product: Product) {
        guard !product.isActuallyOutOfStock else { return }

        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            guard cartItems[index].quantity < product.availableQuantity else { return }
            cartItems[index].quantity += 1
        } else {
            guard product.availableQuantity > 0 else { return }
            cartItems.append(CartItem(product: product, quantity: 1))
        }

        notifyCartUpdated()
    }

    func remove(productId: String) {
        cartItems.removeAll { $0.product.id == productId }

        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func update(productId: String, quantity: Int) {
        guard let index = cartItems.firstIndex(where: { $0.product.id == productId }) else { return }
        cartItems[index].quantity = quantity

        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    private func notifyCartUpdated() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func items() -> [CartItem] { cartItems }

    func summary() -> CartSummary {
        let subtotal = cartItems.reduce(0) {
            $0 + ($1.product.price * Double($1.quantity))
        }
        let discount = offerEngine.discount(for: subtotal)
        let total = max(subtotal - discount, 0)
        return CartSummary(subtotal: subtotal, discount: discount, total: total)
    }
    
    func clear() {
        cartItems.removeAll()
        offerEngine.reset()

        NotificationCenter.default.post(name: .cartUpdated, object: nil)
        NotificationCenter.default.post(name: .offerApplied, object: nil)
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}
