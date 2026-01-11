//
//  AppContainer.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

final class AppContainer {
    
    static let shared = AppContainer()
    private init() {}

    var productListViewModel: ProductListViewModel?
    let offerEngine = OfferEngine()
    lazy var cartService: CartService = CartServiceImpl(offerEngine: offerEngine)
}
