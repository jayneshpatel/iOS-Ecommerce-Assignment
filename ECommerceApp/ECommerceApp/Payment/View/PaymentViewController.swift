//
//  PaymentViewController.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class PaymentViewController: UIViewController {

    private let viewModel: PaymentViewModel

    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Payment"
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

        let amountLabel = UILabel()
        amountLabel.textAlignment = .center
        amountLabel.font = .systemFont(ofSize: 18, weight: .bold)
        amountLabel.text = viewModel.payableAmountText

        stack.addArrangedSubview(amountLabel)

        PaymentMethod.allCases.forEach { method in
            let button = UIButton(type: .system)
            button.setTitle("Pay via \(method.rawValue)", for: .normal)
            button.addTarget(self,
                             action: #selector(paymentTapped(_:)),
                             for: .touchUpInside)
            button.tag = PaymentMethod.allCases.firstIndex(of: method) ?? 0
            stack.addArrangedSubview(button)
        }

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func paymentTapped(_ sender: UIButton) {
        let method = PaymentMethod.allCases[sender.tag]

        Task {
            let result = await viewModel.pay(using: method)
            showResult(result)
        }
    }

    private func showResult(_ result: PaymentResult) {
        switch result {

        case .success(let transactionId):
            let order = Order(
                id: transactionId,
                amount: viewModel.payableAmount,
                date: Date()
            )
            
            AppContainer.shared.cartService.clear()

            let confirmationVM = OrderConfirmationViewModel(order: order)
            let confirmationVC = OrderConfirmationViewController(
                viewModel: confirmationVM
            )

            navigationController?.pushViewController(
                confirmationVC,
                animated: true
            )

        case .failure:
            showRetryAlert(
                title: "Payment Failed",
                message: "Your payment failed. Please try again."
            )

        case .timeout:
            showRetryAlert(
                title: "Payment Timeout",
                message: "Payment timed out. Retry?"
            )
        }
    }
    
    private func showRetryAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "Retry", style: .default)
        )

        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        )

        present(alert, animated: true)
    }
}
