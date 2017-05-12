//
//  HistorialCell.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 5/11/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit
import FirebaseStorage

class HistorialCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblTotal: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //0 product id, 1 registerDate, 2 total, 3 nombre, 4 imageURL, 5 Image
    func configureCell(tuple: (String, String, String, String, String, UIImage?)){
        lblName.text = tuple.3
        lblTotal.text = tuple.2
        lblFecha.text = tuple.1
        
        if tuple.5 != nil {
            productImage.image = tuple.5
        }else{
            let ref = FIRStorage.storage().reference(forURL: tuple.4)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }else{
                    if let imageData = data{
                        if let image = UIImage(data: imageData){
                            self.productImage.image = image
                            HistorialController.imageCache.setObject(image, forKey: tuple.4 as NSString)
                        }
                    }
                }
            })
        }
    }

}
