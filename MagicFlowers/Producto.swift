//
//  Producto.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/12/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Producto {
    
    private var _productId : String
    private var _nombre : String!
    private var _descripcion : String!
    private var _precio : String!
    private var _imagenURL : String!
    private var _productRef : FIRDatabaseReference!
    
    var productId : String{
        return _productId
    }
    
    var nombre : String {
        return _nombre
    }
    
    var descripcion : String {
        return _descripcion
    }
    
    var precio : String {
        return _precio
    }
    
    var imagenURL : String {
        return _imagenURL
    }
    
    var productRef : FIRDatabaseReference {
        return _productRef
    }
    
    
    init(productId: String, postData: [String : Any]) {
        _productId = productId
        
        if let nombre = postData["nombre"] as? String{
            _nombre = nombre
        }
        
        if let descripcion = postData["descripcion"] as? String{
            _descripcion = descripcion
        }
        
        if let precio = postData["precio"] as? String{
            _precio = precio
        }
        
        if let imagenUrl = postData["imageURL"] as? String{
            _imagenURL = imagenUrl
        }
        
        _productRef = DataService.ds.REF_PRODUCTOS.child(productId)
    }
}
