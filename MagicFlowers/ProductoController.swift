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
    var nombreCategoria : String!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = nombreCategoria
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = " "
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let producto = productos[indexPath.row]
        
        performSegue(withIdentifier: "ProductToDetail", sender: producto)
    }

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
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductToDetail"{
            if let destinationVC = segue.destination as? ProductoDetalleController{
                if let prod =  sender as? Producto {
                    if let image = ProductoController.imageCache.object(forKey: prod.imagenURL as NSString){
                        destinationVC.imagen = image
                    }
                    destinationVC.id = prod.productId
                    destinationVC.nombre = prod.nombre
                    destinationVC.descripcion = prod.descripcion
                    destinationVC.precio = prod.precio
                }
            }
        }
    }


}
