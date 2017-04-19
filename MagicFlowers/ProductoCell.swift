//
//  ProductoCell.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/12/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit
import FirebaseStorage

class ProductoCell: UITableViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(producto: Producto, img : UIImage? = nil){
        lblNombre.text = producto.nombre
        lblPrecio.text = producto.precio
        
        if img != nil {
            imagen.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: producto.imagenURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else{
                    if let imageData = data{
                        if let image = UIImage(data: imageData){
                            self.imagen.image = image
                            ProductoController.imageCache.setObject(image, forKey: producto.imagenURL as NSString)
                        }
                    }
                }
            })
        }
    }


}
