//
//  PurchasedViewController.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/6/25.
//

import UIKit

class PurchasedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Purchased Detail"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Purchased Detail"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
}
