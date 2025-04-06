//
//  CodeExtension.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL:", urlString)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self?.image = downloadedImage
                    }
                }
            } catch {
                print("Image download error:", error.localizedDescription)
            }
        }
    }
}


extension UIViewController {
    func showAlert(title: String, message: String, isSuccess: Bool = true) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = isSuccess ? "OK" : "Retry"
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        present(alert, animated: true)
    }
}
extension UIView {
    func roundBottomCorners(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
extension UIView {
    func makeCircular() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
extension UIView {
    func addShadow(color: UIColor = .black,
                   opacity: Float = 0.2,
                   offset: CGSize = CGSize(width: 0, height: 2),
                   radius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}
extension UIButton {
    func animateClick(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1,
                           animations: {
                self.transform = .identity
            }, completion: { _ in
                completion?()
            })
        }
    }
}


extension UIViewController {
    
    private var loaderTag: Int { return 999999 } 
    
    func showLoader() {
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundView.tag = loaderTag
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = backgroundView.center
        activityIndicator.color = .lightGray
        activityIndicator.startAnimating()
        
        backgroundView.addSubview(activityIndicator)
        view.addSubview(backgroundView)
    }
    
    func hideLoader() {
        view.viewWithTag(loaderTag)?.removeFromSuperview()
    }
}

extension UIView {
    func addBorder(color: UIColor = .black, width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
}
