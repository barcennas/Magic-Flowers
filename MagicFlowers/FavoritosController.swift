//
//  FavoritosController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 4/15/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class FavoritosController: UITableViewController {
    
    static var imageCache : NSCache<NSString, UIImage> = NSCache()
    var idFavoritos : [String] = []
    var productos : [Producto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        idFavoritos = []
        productos = []
        getIdFavoritos()
        getFavoritos()
        self.navigationItem.title = "Arreglos Favoritos"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = " "
    }
    
    func getIdFavoritos(){
        let username = UserDefaults.standard.value(forKey: KEY_USERNAME) as! String
        DataService.ds.REF_USERS.child(username).child("productosFavoritos").observeSingleEvent(of: .value, with: { (snapshot) in
            if let favoriteProducts = snapshot.value as? [String: Any] {
                for producto in favoriteProducts {
                    self.idFavoritos.append(producto.key)
                }
            }
            self.idFavoritos.removeFirst()
            print(self.idFavoritos)
            self.getFavoritos()
        })
    }

    func getFavoritos(){
        for idFav in idFavoritos {
            DataService.ds.REF_PRODUCTOS.child(idFav).observeSingleEvent(of: .value, with: { (snapshot) in
                if let productDict = snapshot.value as? [String: Any] {
                    let productId = idFav
                    let producto = Producto(productId: productId, postData: productDict)
                    self.productos.append(producto)
                    self.tableView.reloadData()
                }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let producto = productos[indexPath.row]
        
        performSegue(withIdentifier: "FavoriteToDetail", sender: producto)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteToDetail"{
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
