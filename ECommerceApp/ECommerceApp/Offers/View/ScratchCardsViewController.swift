//
//  ScratchCardsViewController.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class ScratchCardsViewController: UIViewController {

    private let viewModel: ScratchCardsViewModel
    private let tableView = UITableView()

    init(viewModel: ScratchCardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Scratch Cards"
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

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 70

        tableView.register(
            ScratchCardCell.self,
            forCellReuseIdentifier: ScratchCardCell.identifier
        )

        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension ScratchCardsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.cards.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScratchCardCell.identifier,
            for: indexPath
        ) as! ScratchCardCell

        let card = viewModel.cards[indexPath.row]
        cell.configure(with: card, offerApplied: viewModel.isOfferApplied)

        return cell
    }
}

extension ScratchCardsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let success = viewModel.scratchCard(at: indexPath.row)

        if success {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }

        tableView.reloadData()
    }
}
