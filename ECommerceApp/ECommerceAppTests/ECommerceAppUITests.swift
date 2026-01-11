//
//  ECommerceAppUITests.swift
//  ECommerceAppTests
//
//  Created by Jaynesh Patel on 11/01/26.
//

import XCTest

final class ECommerceAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAddProductToCartFlow() {
        let app = XCUIApplication()
        app.launch()

        // Tap first product
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 3))
        firstCell.tap()

        // Add to cart
        let addToCartButton = app.buttons["Add to Cart"]
        XCTAssertTrue(addToCartButton.waitForExistence(timeout: 2))
        addToCartButton.tap()

        // Open cart
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Verify item exists
        XCTAssertTrue(app.tables.cells.count > 0)
    }
}
