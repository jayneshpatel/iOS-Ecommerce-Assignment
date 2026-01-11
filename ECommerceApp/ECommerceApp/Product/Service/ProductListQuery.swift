//
//  ProductListQuery.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

struct ProductListQuery: GraphQLQuery {
    let page: Int

    var mockFileName: String {
        "products_page_\(page)"
    }
}
