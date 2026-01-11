//
//  LoadingViewController.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class LoadingViewController: UIViewController {

    private let logoLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startLoading()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        logoLabel.text = "ECommerceApp"
        logoLabel.font = .systemFont(ofSize: 28, weight: .bold)
        logoLabel.textAlignment = .center

        progressView.progress = 0
        progressView.trackTintColor = .systemGray5
        progressView.tintColor = .systemBlue

        statusLabel.text = "Loading products…"
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [
            logoLabel,
            progressView,
            statusLabel
        ])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }

    private func startLoading() {
        Task {
            // Simulate progressive loading
            await updateProgress(0.3, text: "Fetching products…")
            await loadProducts()

            await updateProgress(0.6, text: "Preparing UI…")
            try? await Task.sleep(nanoseconds: 400_000_000)

            await updateProgress(1.0, text: "Ready")

            transitionToMainApp()
        }
    }

    private func updateProgress(_ value: Float, text: String) async {
        await MainActor.run {
            UIView.animate(withDuration: 0.3) {
                self.progressView.setProgress(value, animated: true)
                self.statusLabel.text = text
            }
        }
    }

    private func loadProducts() async {
        let graphQLClient = MockGraphQLClient()
        let productService = ProductServiceImpl(graphQLClient: graphQLClient)
        let viewModel = ProductListViewModel(productService: productService)

        // preload first page
        await viewModel.loadNextPage()

        AppContainer.shared.productListViewModel = viewModel
    }

    private func transitionToMainApp() {
        let vm = AppContainer.shared.productListViewModel!
        let productListVC = ProductListViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: productListVC)

        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true)
    }
}
