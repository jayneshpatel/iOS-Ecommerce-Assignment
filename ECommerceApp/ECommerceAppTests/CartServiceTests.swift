//
//  CartServiceTests.swift
//  ECommerceAppTests
//
//  Created by Jaynesh Patel on 10/01/26.
//

import XCTest
@testable import ECommerceApp

final class CartServiceTests: XCTestCase {

    private var cartService: CartService!
    private var offerEngine: OfferEngine!

    override func setUp() {
        super.setUp()
        offerEngine = OfferEngine()
        cartService = CartServiceImpl(offerEngine: offerEngine)
    }

    override func tearDown() {
        cartService = nil
        offerEngine = nil
        super.tearDown()
    }

    func testCartSubtotalCalculation() throws {

        let json = """
        {
          "products": [
            {
              "id": "1",
              "name": "Test Product 1",
              "price": 100,
              "imageURL": "",
              "isOutOfStock": false,
              "availableQuantity": 10,
              "description": "Test"
            },
            {
              "id": "2",
              "name": "Test Product 2",
              "price": 200,
              "imageURL": "",
              "isOutOfStock": false,
              "availableQuantity": 10,
              "description": "Test"
            }
          ]
        }
        """

        let data = Data(json.utf8)
        let response = try JSONDecoder().decode(ProductListResponse.self, from: data)

        let product1 = response.products[0]
        let product2 = response.products[1]

        cartService.add(product: product1)
        cartService.add(product: product1)
        cartService.add(product: product2)

        let summary = cartService.summary()

        XCTAssertEqual(summary.subtotal, 400)
        XCTAssertEqual(summary.discount, 0)
        XCTAssertEqual(summary.total, 400)
    }
}
