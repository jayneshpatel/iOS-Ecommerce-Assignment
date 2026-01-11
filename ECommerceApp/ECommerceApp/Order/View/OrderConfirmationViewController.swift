//
//  OrderConfirmationViewController.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class OrderConfirmationViewController: UIViewController {

    private let viewModel: OrderConfirmationViewModel

    init(viewModel: OrderConfirmationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Order Confirmed"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center

        let successLabel = UILabel()
        successLabel.text = "✅ Order Placed Successfully"
        successLabel.font = .systemFont(ofSize: 20, weight: .bold)

        let orderIdLabel = UILabel()
        orderIdLabel.text = viewModel.orderIdText
        orderIdLabel.numberOfLines = 0
        orderIdLabel.textAlignment = .center
        orderIdLabel.lineBreakMode = .byWordWrapping

        let amountLabel = UILabel()
        amountLabel.text = viewModel.amountText

        let dateLabel = UILabel()
        dateLabel.text = viewModel.dateText

        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue Shopping", for: .normal)
        continueButton.addTarget(self,
                                 action: #selector(continueShopping),
                                 for: .touchUpInside)

        stack.addArrangedSubview(successLabel)
        stack.addArrangedSubview(orderIdLabel)
        stack.addArrangedSubview(amountLabel)
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(continueButton)

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func continueShopping() {
        navigationController?.popToRootViewController(animated: true)
    }
}
