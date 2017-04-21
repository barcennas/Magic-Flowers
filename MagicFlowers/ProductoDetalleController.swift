//
//  ProductoDetalleController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/13/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class ProductoDetalleController: UIViewController {

    @IBOutlet weak var ImagenProducto: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    var id: String!
    var nombre: String!
    var descripcion: String!
    var precio: String!
    var imagen: UIImage!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        
        ImagenProducto.image = imagen
        createScrollView()
    }
    
    func configureNavigationBar(){
        self.navigationItem.title = "Detalle"
        
        username = UserDefaults.standard.value(forKey: KEY_USERNAME) as! String
        DataService.ds.REF_USERS.child(username).child("productosFavoritos").observeSingleEvent(of: .value, with: { (snapshot) in
            if let favoriteProducts = snapshot.value as? [String: Any] {
                if (favoriteProducts[self.id]) != nil {
                    print("Es Favorito")
                    let heartButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heartFilled"), style: .plain, target: self, action: #selector(self.removeFromFavorite))
                    self.navigationItem.setRightBarButton(heartButton, animated: true)
                }else{
                    print("No Es Favorito")
                    let heartButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heartEmpty"), style: .plain, target: self, action: #selector(self.addToFavorite))
                    self.navigationItem.setRightBarButton(heartButton, animated: true)

                }
            }
        })
    }
    
    func addToFavorite(){
        let values = [id : true]
        DataService.ds.REF_USERS.child(username).child("productosFavoritos").updateChildValues(values)
        let heartButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heartFilled"), style: .plain, target: self, action: #selector(self.removeFromFavorite))
        self.navigationItem.setRightBarButton(heartButton, animated: true)
    }
    
    func removeFromFavorite(){
        DataService.ds.REF_USERS.child(username).child("productosFavoritos").child(id).removeValue()
        let heartButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heartEmpty"), style: .plain, target: self, action: #selector(self.addToFavorite))
        self.navigationItem.setRightBarButton(heartButton, animated: true)
    }
    
    func createScrollView(){
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 10, width: bottomView.bounds.width-20, height: bottomView.bounds.height-10))
        
        let texto = "\(nombre!) \n \nDescripcion del producto: \n\(descripcion!) \n \nPrecio: \(precio!)"
        
        let lblDetail = UILabel(frame: CGRect(x: 0, y: 10, width: scrollView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        lblDetail.numberOfLines = 0
        lblDetail.lineBreakMode = .byWordWrapping
        lblDetail.text = "\(texto)"
        lblDetail.sizeToFit()
        scrollView.contentSize = lblDetail.bounds.size
        scrollView.addSubview(lblDetail)
        bottomView.addSubview(scrollView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmOrder"{
            if let orderVC = segue.destination as? OrderController {
                orderVC.id = self.id
                orderVC.imagen = self.imagen
                orderVC.nombre = self.nombre
                orderVC.precio = self.precio
            }
        }
    }

}
