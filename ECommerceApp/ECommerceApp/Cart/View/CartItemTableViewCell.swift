//
//  CartItemTableViewCell.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class CartItemTableViewCell: UITableViewCell {

    static let identifier = "CartItemTableViewCell"

    // MARK: UI
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stepper = UIStepper()
    private let qtyLabel = UILabel()

    // MARK: Callback
    private var onQuantityChange: ((Int) -> Void)?

    // MARK: Init
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onQuantityChange = nil
    }

    // MARK: UI Setup
    private func setupUI() {
        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.numberOfLines = 2

        priceLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        priceLabel.textAlignment = .right

        qtyLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        qtyLabel.textAlignment = .center
        qtyLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true

        stepper.minimumValue = 0
        stepper.maximumValue = 99

        [nameLabel, priceLabel, qtyLabel, stepper].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -12),

            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            stepper.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            stepper.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),

            qtyLabel.leadingAnchor.constraint(equalTo: stepper.trailingAnchor, constant: 8),
            qtyLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),

            contentView.bottomAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 12)
        ])
    }

    // MARK: Configure
    func configure(with item: CartItem,
                   onQuantityChange: @escaping (Int) -> Void) {

        self.onQuantityChange = onQuantityChange

        nameLabel.text = item.product.name
        updatePrice(item: item)

        stepper.value = Double(item.quantity)
        qtyLabel.text = "\(item.quantity)"

        stepper.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }

                let newQty = Int(self.stepper.value)

                // 🔔 Haptic
                UIImpactFeedbackGenerator(style: .light).impactOccurred()

                // 🧹 If quantity = 0 → delete
                if newQty == 0 {
                    self.onQuantityChange?(0)
                    return
                }

                self.qtyLabel.text = "\(newQty)"

                // 💸 Animate price
                UIView.transition(
                    with: self.priceLabel,
                    duration: 0.25,
                    options: .transitionCrossDissolve
                ) {
                    self.priceLabel.text =
                        "₹\(Int(item.product.price * Double(newQty)))"
                }

                self.onQuantityChange?(newQty)
            },
            for: .valueChanged
        )
    }

    private func updatePrice(item: CartItem) {
        priceLabel.text =
        "₹\(Int(item.product.price * Double(item.quantity)))"
    }
}
