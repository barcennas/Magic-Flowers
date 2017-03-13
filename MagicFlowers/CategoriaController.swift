//
//  CategoriaController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/12/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class CategoriaController: UITableViewController {
    
    var categorias : [Categoria] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.REF_CATEGORIES.observe(.value, with: { (snapshot) in
            self.categorias = []
            if let categoriesDict = snapshot.value as? [String : Any] {
                for cat in categoriesDict{
                    if let catDict = cat.value as? [String : Any]{
                        if let products = catDict["products"] as? [String : Any]{
                            if let isEnabled = catDict["isEnabled"] as? Bool {
                                if isEnabled{
                                    let nuevaCategoria = Categoria(nombre: cat.key)
                                    for product in products{
                                        nuevaCategoria.addProduct(producto: product.key)
                                    }
                                    self.categorias.append(nuevaCategoria)
                                }
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }

    // MARK: - Table view Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoria = categorias[indexPath.row]
        let productsIds = categoria.productos
        performSegue(withIdentifier: "categorieToProduct", sender: productsIds)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoria = categorias[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriaCell", for: indexPath) as? CategoriaCell {
            cell.configureCell(categoria: categoria)
            return cell
        }
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categorieToProduct" {
            if let destinoVC = segue.destination as? ProductoController {
                if let productIds = sender as? [String]{
                    destinoVC.productId = productIds
                }
            }
        }
    }

}
