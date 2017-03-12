//
//  RoundButton.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/11/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
}
