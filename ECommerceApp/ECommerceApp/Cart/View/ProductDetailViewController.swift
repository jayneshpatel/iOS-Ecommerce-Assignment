//
//  ProductDetailViewController.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class ProductDetailViewController: UIViewController {

    private let viewModel: ProductDetailViewModel

    // MARK: - UI
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stockLabel = UILabel()

    // CTA
    private let addToCartButton = UIButton(type: .system)

    // Stepper
    private let stepperStack = UIStackView()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let quantityLabel = UILabel()

    // Layout
    private let infoStack = UIStackView()
    private let actionStack = UIStackView()
    private let ctaSlotView = UIView() // 🔑 fixed-width container

    // MARK: - Init
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Product Details"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        configure()
        refreshUI(animated: false)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidUpdate),
            name: .cartUpdated,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI(animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart"),
            style: .plain,
            target: self,
            action: #selector(goToCartTapped)
        )
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        // Labels
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.numberOfLines = 0

        priceLabel.font = .systemFont(ofSize: 18, weight: .medium)
        priceLabel.textColor = .secondaryLabel

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        stockLabel.font = .systemFont(ofSize: 14, weight: .medium)

        // Info Stack
        infoStack.axis = .vertical
        infoStack.spacing = 8
        [nameLabel, priceLabel, descriptionLabel, stockLabel].forEach {
            infoStack.addArrangedSubview($0)
        }

        // Add to Cart Button
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        // Stepper
        stepperStack.axis = .horizontal
        stepperStack.spacing = 20
        stepperStack.alignment = .center
        stepperStack.isHidden = true

        styleStepperButton(minusButton, title: "–")
        styleStepperButton(plusButton, title: "+")

        quantityLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        quantityLabel.textAlignment = .center
        quantityLabel.widthAnchor.constraint(equalToConstant: 32).isActive = true

        stepperStack.addArrangedSubview(minusButton)
        stepperStack.addArrangedSubview(quantityLabel)
        stepperStack.addArrangedSubview(plusButton)

        // CTA SLOT (critical fix)
        ctaSlotView.translatesAutoresizingMaskIntoConstraints = false
        ctaSlotView.widthAnchor.constraint(equalToConstant: 260).isActive = true
        ctaSlotView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        ctaSlotView.addSubview(addToCartButton)
        ctaSlotView.addSubview(stepperStack)

        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        stepperStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addToCartButton.centerXAnchor.constraint(equalTo: ctaSlotView.centerXAnchor),
            addToCartButton.centerYAnchor.constraint(equalTo: ctaSlotView.centerYAnchor),

            stepperStack.centerXAnchor.constraint(equalTo: ctaSlotView.centerXAnchor),
            stepperStack.centerYAnchor.constraint(equalTo: ctaSlotView.centerYAnchor)
        ])

        // Action Stack
        actionStack.axis = .vertical
        actionStack.spacing = 24
        actionStack.alignment = .center
        actionStack.addArrangedSubview(ctaSlotView)

        // Add Views
        [imageView, infoStack, actionStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.heightAnchor.constraint(equalToConstant: 220),

            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            actionStack.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 28),
            actionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Actions
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
    }

    private func styleStepperButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    // MARK: - Configure
    private func configure() {
        nameLabel.text = viewModel.productName
        priceLabel.text = viewModel.priceText
        descriptionLabel.text = viewModel.descriptionText
        stockLabel.text = viewModel.stockText
        stockLabel.textColor = viewModel.isOutOfStock ? .systemRed : .systemGreen

        ImageLoader.shared.loadImage(from: viewModel.product.imageURL) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    @objc private func cartDidUpdate() {
        refreshUI(animated: false)
    }

    // MARK: - Actions
    @objc private func addToCartTapped() {
        viewModel.addToCart()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        refreshUI()
    }

    @objc private func increaseTapped() {
        viewModel.increaseQuantity()
        refreshUI()
    }

    @objc private func decreaseTapped() {
        viewModel.decreaseQuantity()
        refreshUI()
    }

    @objc private func goToCartTapped() {
        let cartVC = CartViewController(
            viewModel: CartViewModel(cartService: AppContainer.shared.cartService)
        )
        navigationController?.pushViewController(cartVC, animated: true)
    }

    // MARK: - UI State (FINAL & STABLE)
    private func refreshUI(animated: Bool = true) {
        let qty = viewModel.currentQuantity()
        let outOfStock = viewModel.isOutOfStock

        let changes = {
            if outOfStock {
                self.addToCartButton.isHidden = true
                self.stepperStack.isHidden = true
                return
            }

            if qty == 0 {
                self.addToCartButton.isHidden = false
                self.stepperStack.isHidden = true
            } else {
                self.addToCartButton.isHidden = true
                self.stepperStack.isHidden = false
                self.quantityLabel.text = "\(qty)"
            }
        }

        animated
            ? UIView.animate(withDuration: 0.25, animations: changes)
            : changes()
    }
}
