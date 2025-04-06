//
//  HomeViewController.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ProductListViewModel()
    private let emptyStateLabel: UILabel = {
          let label = UILabel()
          label.text = "No products found."
          label.textAlignment = .center
          label.textColor = .white
          label.font = .systemFont(ofSize: 18, weight: .medium)
          label.isHidden = true
          return label
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        setupThemeButton()
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .clear
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        bindViewModel()
        tableView.backgroundView = emptyStateLabel
        viewModel.fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Products"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .label
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    private func bindViewModel() {
        self.showLoader()
        viewModel.onProductsUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.hideLoader()
        }

        viewModel.onFetchFailed = { [weak self] errorMessage, retry in
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                retry()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
    
    private func updateEmptyState() {
           emptyStateLabel.isHidden = viewModel.numberOfProducts() > 0
       }
    
    func setupThemeButton() {
        let icon = ThemeManager.shared.currentTheme == .dark ? "☀️" : "🌙"
        let toggleItem = UIBarButtonItem(title: icon, style: .plain, target: self, action: #selector(toggleTheme))
        navigationItem.rightBarButtonItem = toggleItem
    }
    @objc func toggleTheme() {
        let current = ThemeManager.shared.currentTheme
        let newTheme: AppTheme = (current == .light) ? .dark : .light
        ThemeManager.shared.currentTheme = newTheme
        setupThemeButton() 
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfProducts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = viewModel.product(at: indexPath.section)
        cell.configure(with: product)
        cell.backgroundColor = .secondarySystemBackground 
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = viewModel.product(at: indexPath.section)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
            vc.product = selectedProduct
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

