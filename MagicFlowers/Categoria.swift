//
//  Categoria.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/12/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import Foundation

class Categoria {
    
    private var _nombre : String!
    private var _productos : [String]!
    
    var nombre : String {
        get{
            return _nombre
        }set{
            _nombre = nombre
        }
    }
    
    var productos : [String]{
        get{
            return _productos
        }
    }
    
    func addProduct(producto: String){
        _productos.append(producto)
    }
    
    init(nombre: String) {
        _nombre = nombre
        _productos = []
    }
}
