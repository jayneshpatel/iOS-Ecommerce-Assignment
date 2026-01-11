//
//  ProductDetailViewModel.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

@MainActor
final class ProductDetailViewModel {

    let product: Product
    private let cartService: CartService

    init(product: Product, cartService: CartService) {
        self.product = product
        self.cartService = cartService
    }

    var productName: String {
        product.name
    }

    var priceText: String {
        "₹\(Int(product.price))"
    }

    var isOutOfStock: Bool {
        product.isActuallyOutOfStock
    }
    
    var descriptionText: String {
        product.description
    }

    var stockText: String {
        product.availableQuantity > 0
        ? "In Stock (\(product.availableQuantity) available)"
        : "Out of Stock"
    }

    func addToCart() {
        guard !product.isOutOfStock else { return }
        cartService.add(product: product)
    }
    
    func addToCartAndGetSummary() -> CartSummary {
        guard !product.isOutOfStock else {
            return cartService.summary()
        }

        cartService.add(product: product)
        return cartService.summary()
    }
}

extension ProductDetailViewModel {

    func currentQuantity() -> Int {
        cartService.items()
            .first(where: { $0.product.id == product.id })?
            .quantity ?? 0
    }

    func increaseQuantity() {
        let current = currentQuantity()
        guard current < product.availableQuantity else { return }
        cartService.add(product: product)
    }

    func decreaseQuantity() {
        let qty = currentQuantity()

        if qty <= 1 {
            cartService.remove(productId: product.id)
        } else {
            cartService.update(productId: product.id, quantity: qty - 1)
        }
    }
}
