//
//  ProductDetailViewController.swift
//  9xdGo
//
//  Created by 이재성 on 09/09/2017.
//  Copyright © 2017 이재성. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDetail: UILabel!
    var image: UIImage?
    var productName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = image, let productName = productName else { return }
        productImage.image = image
        productTitle.text = productName
        productDetail.text = "얘는 \(productName)입니다 사세염"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closteButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
