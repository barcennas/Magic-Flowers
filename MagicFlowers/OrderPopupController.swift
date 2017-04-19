//
//  OrderPopupController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 4/18/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class OrderPopupController: UIViewController {
    
    @IBOutlet weak var textVIew: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
    }
    
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        print(textVIew.text)
    }

    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion:  nil)
    }
}
