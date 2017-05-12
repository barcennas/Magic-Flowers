//
//  HistorialController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 5/11/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class HistorialController: UITableViewController {
    
    static var imageCache : NSCache<NSString, UIImage> = NSCache()
    var idOrdenes : [String] = []
    var orders : [(String, String, String)] = []
    var items : [(String, String, String, String, String, UIImage?)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getOrdenesIds()
    }
    
    func getOrdenesIds(){
        let username = UserDefaults.standard.value(forKey: KEY_USERNAME) as! String
        DataService.ds.REF_USERS.child(username).child("orders").observeSingleEvent(of: .value, with: { (snapshot) in
            if let historyOrders = snapshot.value as? [String: Any] {
                for order in historyOrders {
                    self.idOrdenes.append(order.key)
                }
            }
            self.getOrdersDetail()
        })
    }
    
    func getOrdersDetail(){
        print(idOrdenes)
        for idOrder in idOrdenes {
            DataService.ds.REF_ORDERS.child(idOrder).observeSingleEvent(of: .value, with: { (snapshot) in
                if let orderDict = snapshot.value as? [String: Any] {
                    guard let productId = orderDict["productId"] as? String else {return}
                    guard let registerDate = orderDict["registerDate"] as? String else {return}
                    guard let total = orderDict["total"] as? String else {return}
                    self.orders.append((productId, registerDate, total))
                }
                if idOrder == self.idOrdenes.last {
                    self.getProductDetail()
                }
            })
        }
    }
    
    func getProductDetail(){
        print(orders)
        for order in orders {
            DataService.ds.REF_PRODUCTOS.child(order.0).observeSingleEvent(of: .value, with: { (snapshot) in
                if let productDict = snapshot.value as? [String: Any] {
                    guard let nombre = productDict["nombre"] as? String else {return}
                    guard let imageURL = productDict["imageURL"] as? String else {return}
                    if let image = HistorialController.imageCache.object(forKey: imageURL as NSString){
                        self.items.append((order.0, order.1, order.2, nombre, imageURL, image))
                    }else{
                        self.items.append((order.0, order.1, order.2, nombre, imageURL, nil))
                    }
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        print(item)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistorialCell", for: indexPath) as? HistorialCell {
            cell.configureCell(tuple: item)
            return cell
        }
        return UITableViewCell()
    }



}
