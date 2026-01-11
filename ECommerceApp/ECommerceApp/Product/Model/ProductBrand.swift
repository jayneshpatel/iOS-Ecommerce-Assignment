//
//  ProductBrand.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

enum ProductBrand: String, CaseIterable {
    case apple = "Apple"
    case samsung = "Samsung"
    case google = "Google"
    case sony = "Sony"
    case others = "Others"

    static func from(name: String) -> ProductBrand {
        let lower = name.lowercased()

        if lower.contains("iphone")
            || lower.contains("ipad")
            || lower.contains("mac")
            || lower.contains("apple")
            || lower.contains("airpods") {
            return .apple
        }

        if lower.contains("samsung") {
            return .samsung
        }

        if lower.contains("pixel") {
            return .google
        }

        if lower.contains("sony") {
            return .sony
        }

        return .others
    }
}
