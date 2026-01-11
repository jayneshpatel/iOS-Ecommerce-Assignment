//
//  ProductServiceImpl.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

final class ProductServiceImpl: ProductService {

    private let graphQLClient: GraphQLClient

    init(graphQLClient: GraphQLClient) {
        self.graphQLClient = graphQLClient
    }

    func fetchProducts(page: Int) async throws -> [Product] {
        let response: ProductListResponse =
            try await graphQLClient.query(ProductListQuery(page: page))
        return response.products
    }
}
