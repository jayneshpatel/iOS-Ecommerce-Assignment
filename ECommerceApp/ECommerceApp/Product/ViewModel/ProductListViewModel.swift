//
//  ProductListViewModel.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation
import UIKit

@MainActor
final class ProductListViewModel {

    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }

    private let productService: ProductService
    private(set) var products: [Product] = []
    private(set) var state: State = .idle

    private var currentPage = 1
    private var canLoadMore = true

    init(productService: ProductService) {
        self.productService = productService
    }

    func loadNextPage() async {
        guard canLoadMore else { return }

        if case .loading = state { return }

        state = .loading

        do {
            let newProducts = try await productService.fetchProducts(page: currentPage)

            if newProducts.isEmpty {
                canLoadMore = false
            } else {
                let existingIDs = Set(products.map { $0.id })
                let uniqueNewProducts = newProducts.filter {
                    !existingIDs.contains($0.id)
                }

                products.append(contentsOf: uniqueNewProducts)
                currentPage += 1
            }

            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    var sections: [ProductBrand] {
        ProductBrand.allCases.filter { brand in
            products.contains { $0.brand == brand }
        }
    }

    func numberOfItems(in section: Int) -> Int {
        let brand = sections[section]
        return products.filter { $0.brand == brand }.count
    }

    func product(at indexPath: IndexPath) -> Product {
        let brand = sections[indexPath.section]
        let items = products.filter { $0.brand == brand }
        return items[indexPath.item]
    }
}
