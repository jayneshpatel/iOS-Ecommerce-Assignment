//
//  GraphQLClient.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

protocol GraphQLClient {
    func query<T: Decodable>(_ query: GraphQLQuery) async throws -> T
    func mutate<T: Decodable>(_ mutation: GraphQLMutation) async throws -> T
}

protocol GraphQLQuery {
    var mockFileName: String { get }
}

protocol GraphQLMutation {
    var mockFileName: String { get }
}
