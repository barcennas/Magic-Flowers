//
//  HomeController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/12/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {
    
    var categorias : [Categoria] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.REF_CATEGORIES.observe(.value, with: { (snapshot) in
            self.categorias = []
            if let categoriesDict = snapshot.value as? [String : Any] {
                for cat in categoriesDict{
                    print(cat.key)
                    if let catDict = cat.value as? [String : Any]{
                        print(catDict)
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
        //let categoria = categorias[indexPath.row]
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoria = categorias[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell {
            cell.configureCell(categoria: categoria)
            return cell
        }
        return UITableViewCell()
    }

}
