//
//  Product.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

struct Product: Decodable {
    let id: String
    let name: String
    let price: Double
    let imageURL: String
    let isOutOfStock: Bool
    let availableQuantity: Int
    let description: String

    var brand: ProductBrand {
        ProductBrand.from(name: name)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, price, imageURL, isOutOfStock
        case availableQuantity
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        isOutOfStock = try container.decode(Bool.self, forKey: .isOutOfStock)

        availableQuantity = try container.decodeIfPresent(Int.self, forKey: .availableQuantity) ?? 0
        description = try container.decodeIfPresent(String.self, forKey: .description)
            ?? "No description available."
    }
}

extension Product {
    var isActuallyOutOfStock: Bool {
        isOutOfStock || availableQuantity == 0
    }
}
