//
//  ProductService.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

protocol ProductService {
    func fetchProducts(page: Int) async throws -> [Product]
}
