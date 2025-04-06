//
//  IAPManager.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import Foundation
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    
    private var products = [SKProduct]()
    let productIDs: Set<String> = ["com.speedapps.product1"]
    var purchaseCompletion: ((Bool) -> Void)?
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIDs)
           request.delegate = self
           request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }

    func buyProduct() {
        guard let productToBuy = products.first else {
            print("Product not found")
            return
        }
        let payment = SKPayment(product: productToBuy)
        SKPaymentQueue.default().add(payment)
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase successful!")
                let productID = transaction.payment.productIdentifier
                UserDefaults.standard.set(true, forKey: productID)
                var purchasedIDs = UserDefaults.standard.array(forKey: "purchased_ids") as? [String] ?? []
                if !purchasedIDs.contains(productID) {
                    purchasedIDs.append(productID)
                    UserDefaults.standard.set(purchasedIDs, forKey: "purchased_ids")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                purchaseCompletion?(true)
                
            case .failed:
                print("Purchase failed.")
                SKPaymentQueue.default().finishTransaction(transaction)
                purchaseCompletion?(false)
            default:
                break
            }
        }
    }

}
