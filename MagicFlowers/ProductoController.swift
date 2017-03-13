//
//  ProductoController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/12/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class ProductoController: UITableViewController {

    static var imageCache : NSCache<NSString, UIImage> = NSCache()
    var productId : [String]!
    var productos : [Producto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for id in productId{
            DataService.ds.REF_PRODUCTOS.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let productDict = snapshot.value as? [String: Any] {
                    let productId = id
                    let producto = Producto(productId: productId, postData: productDict)
                    self.productos.append(producto)
                }
                self.tableView.reloadData()
            })
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let producto = productos[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as? ProductoCell {
            if let image = ProductoController.imageCache.object(forKey: producto.imagenURL as NSString){
                cell.configureCell(producto: producto, img: image)
            }else{
                cell.configureCell(producto: producto)
            }
            return cell
        }
        return UITableViewCell()
    }
 



}
