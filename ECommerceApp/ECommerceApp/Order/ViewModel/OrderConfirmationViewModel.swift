//
//  OrderConfirmationViewModel.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import Foundation

final class OrderConfirmationViewModel {

    let order: Order

    init(order: Order) {
        self.order = order
    }

    var orderIdText: String {
        "Order ID: \(order.id)"
    }

    var amountText: String {
        "Amount Paid: ₹\(Int(order.amount))"
    }

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Date: \(formatter.string(from: order.date))"
    }
}
