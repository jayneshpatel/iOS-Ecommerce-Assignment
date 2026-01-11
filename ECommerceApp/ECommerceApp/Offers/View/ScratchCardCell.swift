//
//  ScratchCardCell.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class ScratchCardCell: UITableViewCell {

    static let identifier = "ScratchCardCell"

    private let titleLabel = UILabel()
    private let cardView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        selectionStyle = .none

        cardView.layer.cornerRadius = 12
        cardView.backgroundColor = .systemGray6
        cardView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }

    func configure(with card: ScratchCard, offerApplied: Bool) {
        if card.isScratched {
            titleLabel.text = card.offer.title
            cardView.backgroundColor = .systemGreen.withAlphaComponent(0.15)
        } else {
            titleLabel.text = offerApplied ? "Offer Already Applied" : "🎁 Scratch to Reveal"
            cardView.backgroundColor = offerApplied ? .systemGray4 : .systemBlue.withAlphaComponent(0.15)
        }
    }
}

