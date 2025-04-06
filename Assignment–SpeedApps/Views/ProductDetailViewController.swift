//
//  ProductDetailViewController.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import UIKit
import Kingfisher
class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var product: Product?
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyThemeSupport()
        IAPManager.shared.startObserving()
        IAPManager.shared.fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Product Detail"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }

    func setupUI() {
        guard let product = product else { return }

        titleLabel.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = "Price: ₹\(product.price)"
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"))
        }
        let isPurchased = UserDefaults.standard.bool(forKey: product.title)
        buyButton.isHidden = isPurchased
        productImageView.roundBottomCorners(radius: 30)
        productImageView.addBorder(color: .lightGray, width: 1)
        buyButton.makeCircular()
        buyButton.addShadow()
        
        productImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage))
        productImageView.addGestureRecognizer(tap)
    }

    func applyThemeSupport() {
        view.backgroundColor = .systemBackground
        titleLabel.textColor = .label
        descriptionLabel.textColor = .secondaryLabel
        priceLabel.textColor = .label
    }
    @objc func showFullScreenImage() {
        guard let image = productImageView.image else { return }
        let imageVC = UIViewController()
        imageVC.view.backgroundColor = .black
        let fullImageView = UIImageView(image: image)
        fullImageView.contentMode = .scaleAspectFit
        fullImageView.frame = imageVC.view.frame
        fullImageView.isUserInteractionEnabled = true
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        fullImageView.addGestureRecognizer(dismissTap)
        imageVC.view.addSubview(fullImageView)
        imageVC.modalPresentationStyle = .fullScreen
        present(imageVC, animated: true, completion: nil)
    }
    @objc func dismissFullscreenImage() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func buyButtonTapped(_ sender: UIButton) {
        sender.animateClick {
            guard let productKey = self.product?.title else { return }
            self.showLoader()
            IAPManager.shared.purchaseCompletion = { [weak self] success in
                DispatchQueue.main.async {
                    self?.hideLoader()
                    if success {
                        UserDefaults.standard.set(true, forKey: productKey)
                        self?.buyButton.isHidden = true
                        self?.showAlert(title: "Success", message: "Purchase completed!")
                    } else {
                        self?.showAlert(title: "Error", message: "Something went wrong.", isSuccess: false)
                    }
                }
            }
            IAPManager.shared.buyProduct()
        }
    }
    deinit {
        IAPManager.shared.stopObserving()
    }
}


