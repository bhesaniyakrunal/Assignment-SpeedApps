//
//  Model.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
}
