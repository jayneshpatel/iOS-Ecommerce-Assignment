//
//  Offer.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

protocol Offer {
    var id: String { get }
    var title: String { get }
    func discountAmount(for subtotal: Double) -> Double
}
