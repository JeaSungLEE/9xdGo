//
//  CreditViewController.swift
//  9xdGo
//
//  Created by 이재성 on 10/09/2017.
//  Copyright © 2017 이재성. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController {
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        topConstraint.constant = getScreenSize().height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 20, delay: 0, options: .curveLinear, animations: {
            self.topConstraint.constant = -500
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
