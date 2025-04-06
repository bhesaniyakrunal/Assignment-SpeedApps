//
//  APIService.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//


import Foundation

class APIService {
    static let shared = APIService()

    func fetchProducts(completion: @escaping ([Product]?) -> Void) {
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(products)
            } catch {
                print("Decoding Error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
