//
//  ProductListViewController.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class ProductListViewController: UIViewController {
    
    private let viewModel: ProductListViewModel
    private var collectionView: UICollectionView!
    
    // 🛒 Cart button + badge
    private let cartButton = UIButton(type: .system)
    private let badgeLabel = UILabel()
    
    // MARK: Init
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Products"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCartButton()
        loadProducts()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidUpdate),
            name: .cartUpdated,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartBadge()
    }
    
    // MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ProductGridCell.self,
                                forCellWithReuseIdentifier: ProductGridCell.identifier)
        collectionView.register(BrandSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: BrandSectionHeaderView.identifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Cart Button + Badge
    private func setupCartButton() {
        cartButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        cartButton.tintColor = .label
        cartButton.addTarget(self,
                             action: #selector(openCart),
                             for: .touchUpInside)
        
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textColor = .white
        badgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 9
        badgeLabel.clipsToBounds = true
        badgeLabel.isHidden = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cartButton.addSubview(badgeLabel)
        cartButton.bringSubviewToFront(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -4),
            badgeLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 4),
            badgeLabel.heightAnchor.constraint(equalToConstant: 18),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])
        
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(customView: cartButton)
    }
    
    private func updateCartBadge() {
        let totalQuantity = AppContainer.shared.cartService
            .items()
            .reduce(0) { $0 + $1.quantity }

        badgeLabel.isHidden = totalQuantity == 0
        badgeLabel.text = "\(totalQuantity)"

        // Optional animation (recommended)
        if totalQuantity > 0 {
            UIView.animate(withDuration: 0.15,
                           animations: {
                self.badgeLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    self.badgeLabel.transform = .identity
                }
            }
        }
    }
    
    // MARK: Data
    private func loadProducts() {
        Task {
            await viewModel.loadNextPage()
            collectionView.reloadData()
        }
    }
    
    private func setupCartObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidUpdate),
            name: .cartUpdated,
            object: nil
        )
    }
    
    @objc private func cartDidUpdate() {
        updateCartBadge()
    }
    
    // MARK: Navigation
    @objc private func openCart() {
        let vm = CartViewModel(cartService: AppContainer.shared.cartService)
        let vc = CartViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionView DataSource
extension ProductListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductGridCell.identifier,
            for: indexPath
        ) as! ProductGridCell
        
        cell.configure(with: viewModel.product(at: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath)
    -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: BrandSectionHeaderView.identifier,
            for: indexPath
        ) as! BrandSectionHeaderView
        
        header.configure(title: viewModel.sections[indexPath.section].rawValue)
        return header
    }
}

// MARK: - UICollectionView Delegate
extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let product = viewModel.product(at: indexPath)
        let vm = ProductDetailViewModel(
            product: product,
            cartService: AppContainer.shared.cartService
        )
        
        let vc = ProductDetailViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 170, height: 180)
    }
}
