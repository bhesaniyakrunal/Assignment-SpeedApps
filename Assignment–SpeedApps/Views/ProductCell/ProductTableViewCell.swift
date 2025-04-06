//
//  ProductTableViewCell.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.textColor = .systemGreen
        productImageView.makeCircular()
        self.productImageView.addBorder(color: .lightGray, width: 0.5)
    }

    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "₹\(product.price)"
        productImageView.loadImage(from: product.image, placeholder: UIImage(named: "placeholder"))
    }
}
