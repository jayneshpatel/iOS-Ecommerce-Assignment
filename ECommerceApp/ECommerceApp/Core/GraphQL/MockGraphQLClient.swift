//
//  MockGraphQLClient.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

enum MockGraphQLError: Error {
    case fileNotFound
    case decodingFailed
}

final class MockGraphQLClient: GraphQLClient {

    func query<T: Decodable>(_ query: GraphQLQuery) async throws -> T {
        try await simulateNetworkDelay()
        return try loadMockResponse(named: query.mockFileName)
    }

    func mutate<T: Decodable>(_ mutation: GraphQLMutation) async throws -> T {
        try await simulateNetworkDelay()
        return try loadMockResponse(named: mutation.mockFileName)
    }

    // MARK: - Helpers

    private func simulateNetworkDelay() async throws {
        try await Task.sleep(nanoseconds: 800_000_000)
    }

    private func loadMockResponse<T: Decodable>(named fileName: String) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw MockGraphQLError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw MockGraphQLError.decodingFailed
        }
    }
}
