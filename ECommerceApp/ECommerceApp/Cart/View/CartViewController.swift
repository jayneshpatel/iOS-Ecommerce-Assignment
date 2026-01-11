//
//  CartViewController.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class CartViewController: UIViewController {

    private let viewModel: CartViewModel

    private let offersButton = UIButton(type: .system)
    private let tableView = UITableView()
    private let appliedOfferLabel = UILabel()
    private let summaryContainer = UIStackView()

    private let subtotalTitleLabel = UILabel()
    private let subtotalValueLabel = UILabel()

    private let discountTitleLabel = UILabel()
    private let discountValueLabel = UILabel()

    private let totalTitleLabel = UILabel()
    private let totalValueLabel = UILabel()

    private var checkoutButton: UIBarButtonItem!
    private let emptyStateView = UIView()
    private let emptyIcon = UIImageView()
    private let emptyTitleLabel = UILabel()
    private let emptySubtitleLabel = UILabel()
    private let shopButton = UIButton(type: .system)

    // MARK: Init
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Cart"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupEmptyState()

        // ✅ CREATE BUTTON FIRST
        checkoutButton = UIBarButtonItem(
            title: "Checkout",
            style: .done,
            target: self,
            action: #selector(openPayment)
        )
        navigationItem.rightBarButtonItem = checkoutButton

        // ✅ NOW SAFE TO CALL
        updateSummary()
        updateEmptyState()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(offerDidUpdate),
            name: .offerApplied,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidUpdate),
            name: .cartUpdated,
            object: nil
        )
    }

    // MARK: UI
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // 🎁 Offers Button
        offersButton.setTitle("🎁 Apply Offer / Scratch Card", for: .normal)
        offersButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        offersButton.backgroundColor = .systemYellow.withAlphaComponent(0.25)
        offersButton.layer.cornerRadius = 12
        offersButton.addTarget(self, action: #selector(openOffers), for: .touchUpInside)
        offersButton.translatesAutoresizingMaskIntoConstraints = false

        // TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            CartItemTableViewCell.self,
            forCellReuseIdentifier: CartItemTableViewCell.identifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Summary
        summaryContainer.axis = .vertical
        summaryContainer.spacing = 6
        summaryContainer.alignment = .fill
        summaryContainer.translatesAutoresizingMaskIntoConstraints = false
        summaryContainer.backgroundColor = .secondarySystemBackground
        summaryContainer.layer.cornerRadius = 12
        summaryContainer.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        summaryContainer.isLayoutMarginsRelativeArrangement = true

        summaryContainer.addArrangedSubview(
            makeSummaryRow(
                titleLabel: subtotalTitleLabel,
                valueLabel: subtotalValueLabel
            )
        )

        summaryContainer.addArrangedSubview(
            makeSummaryRow(
                titleLabel: discountTitleLabel,
                valueLabel: discountValueLabel
            )
        )

        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        summaryContainer.addArrangedSubview(divider)

        summaryContainer.addArrangedSubview(
            makeSummaryRow(
                titleLabel: totalTitleLabel,
                valueLabel: totalValueLabel,
                isBold: true
            )
        )


        view.addSubview(summaryContainer)
        
        appliedOfferLabel.font = .systemFont(ofSize: 14, weight: .medium)
        appliedOfferLabel.textColor = .systemGreen
        appliedOfferLabel.textAlignment = .center
        appliedOfferLabel.numberOfLines = 0
        appliedOfferLabel.isHidden = true
        appliedOfferLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(appliedOfferLabel)
        view.addSubview(offersButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            offersButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            offersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            offersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            offersButton.heightAnchor.constraint(equalToConstant: 48),

            appliedOfferLabel.topAnchor.constraint(equalTo: offersButton.bottomAnchor, constant: 6),
            appliedOfferLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appliedOfferLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: appliedOfferLabel.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            summaryContainer.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            summaryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupEmptyState() {

        emptyIcon.image = UIImage(systemName: "cart")
        emptyIcon.tintColor = .systemGray
        emptyIcon.contentMode = .scaleAspectFit
        emptyIcon.translatesAutoresizingMaskIntoConstraints = false

        emptyTitleLabel.text = "Your cart is empty"
        emptyTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        emptyTitleLabel.textAlignment = .center

        emptySubtitleLabel.text = "Looks like you haven’t added anything yet"
        emptySubtitleLabel.font = .systemFont(ofSize: 14)
        emptySubtitleLabel.textColor = .secondaryLabel
        emptySubtitleLabel.textAlignment = .center

        shopButton.setTitle("Start Shopping", for: .normal)
        shopButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        shopButton.addTarget(self, action: #selector(goBackToProducts), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            emptyIcon,
            emptyTitleLabel,
            emptySubtitleLabel,
            shopButton
        ])

        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        emptyStateView.addSubview(stack)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyIcon.heightAnchor.constraint(equalToConstant: 64),
            emptyIcon.widthAnchor.constraint(equalToConstant: 64),

            stack.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
        ])
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.numberOfItems() == 0

        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        summaryContainer.isHidden = isEmpty
        offersButton.isHidden = isEmpty

        // ✅ ADD THIS LINE
        checkoutButton?.isHidden = isEmpty
    }
    
    private func makeSummaryRow(
        titleLabel: UILabel,
        valueLabel: UILabel,
        isBold: Bool = false
    ) -> UIStackView {

        titleLabel.font = isBold
            ? .systemFont(ofSize: 17, weight: .bold)
            : .systemFont(ofSize: 15, weight: .medium)

        valueLabel.font = titleLabel.font
        valueLabel.textAlignment = .right

        let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        row.axis = .horizontal
        row.distribution = .fill
        row.alignment = .center

        return row
    }

    // MARK: Actions
    @objc private func openOffers() {
        let vm = ScratchCardsViewModel(
            offerEngine: AppContainer.shared.offerEngine
        )
        let vc = ScratchCardsViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openPayment() {
        let summary = viewModel.summary
        let paymentVM = PaymentViewModel(
            paymentService: DummyPaymentService(),
            amount: summary.total
        )
        let vc = PaymentViewController(viewModel: paymentVM)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: Summary
    private func updateSummary() {
        let summary = viewModel.summary

        subtotalTitleLabel.text = "Subtotal"
        subtotalValueLabel.text = "₹\(Int(summary.subtotal))"

        if summary.discount > 0 {
            discountTitleLabel.text = "Discount"
            discountValueLabel.text = "-₹\(Int(summary.discount))"
            discountValueLabel.textColor = .systemGreen
            discountTitleLabel.isHidden = false
            discountValueLabel.isHidden = false
        } else {
            discountTitleLabel.isHidden = true
            discountValueLabel.isHidden = true
        }

        totalTitleLabel.text = "Total"
        totalValueLabel.text = "₹\(Int(summary.total))"
    }

    @objc private func offerDidUpdate() {
        updateSummary()
    }
    
    @objc private func cartDidUpdate() {
        tableView.reloadData()
        updateSummary()
        updateEmptyState()
    }
    
    @objc private func goBackToProducts() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemTableViewCell.identifier,
            for: indexPath
        ) as! CartItemTableViewCell

        let item = viewModel.item(at: indexPath.row)

        cell.configure(with: item) { [weak self] newQty in
            guard let self else { return }

            if newQty == 0 {
                self.viewModel.removeItem(productId: item.product.id)
            } else {
                self.viewModel.updateQuantity(
                    productId: item.product.id,
                    quantity: newQty
                )
            }

            self.tableView.reloadData()
            self.updateSummary()
            self.updateEmptyState()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }

        let item = viewModel.item(at: indexPath.row)
        viewModel.removeItem(productId: item.product.id)

        // ✅ SINGLE SOURCE OF TRUTH
        tableView.reloadData()
        updateSummary()
        updateEmptyState()
    }
}
