//
//  ViewModels.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import Foundation

class ProductListViewModel {
    
    var products: [Product] = []
    var onProductsUpdated: (() -> Void)?
    var onFetchFailed: ((_ errorMessage: String, _ retryHandler: @escaping () -> Void) -> Void)?

    func fetchProducts(retryCount: Int = 3, delay: TimeInterval = 2.0) {
        APIService.shared.fetchProducts { [weak self] fetchedProducts in
            guard let self = self else { return }
            
            if let fetchedProducts = fetchedProducts {
                self.products = fetchedProducts
                DispatchQueue.main.async {
                    self.onProductsUpdated?()
                }
            } else {
                if retryCount > 0 {
                    // Retry after delay
                    DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                        self.fetchProducts(retryCount: retryCount - 1, delay: delay)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.onFetchFailed?(
                            "Failed to load products. Please check your internet connection.",
                            { [weak self] in self?.fetchProducts() }
                        )
                    }
                }
            }
        }
    }
    
    func product(at index: Int) -> Product {
        return products[index]
    }
    
    func numberOfProducts() -> Int {
        return products.count
    }
}
