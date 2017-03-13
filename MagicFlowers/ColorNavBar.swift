//
//  ColorNavBar.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/12/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class ColorNavBar: UINavigationBar {

    override func awakeFromNib() {
        let font = UIFont(name: "Avenir-Next-Regular", size: 15)
        barTintColor = PRIMARY_COLOR
        tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        titleTextAttributes = [NSForegroundColorAttributeName : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                               NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 25)!]
    }

}
