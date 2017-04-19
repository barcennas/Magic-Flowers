//
//  DataService.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/11/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
//import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CATEGORIES = DB_BASE.child("categories")
    private var _REF_PRODUCTOS = DB_BASE.child("products")
    private var _REF_ITEMS_IMAGES = STORAGE_BASE.child("item-images")
    
    var REF_USERS : FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_CATEGORIES : FIRDatabaseReference {
        return _REF_CATEGORIES
    }
    
    var REF_PRODUCTOS : FIRDatabaseReference {
        return _REF_PRODUCTOS
    }
    
    var REF_ITEM_IMAGES : FIRStorageReference {
        return _REF_ITEMS_IMAGES
    }
    
    /*var REF_USER_CURRENT : FIRDatabaseReference{
        if let username = KeychainWrapper.standard.string(forKey: KEY_USERNAME){
            let user = REF_USERS.child(username)
            return user
        }
        print("Error while getting EF_USER_CURRENT")
        return FIRDatabaseReference()
    }*/
    
    func createFirebaseDBUser(user: String, userData: [String : Any]){
        var stardaCreationData = userData
        stardaCreationData["productosFavoritos"] = ["Default": true]
        REF_USERS.child(user).updateChildValues(stardaCreationData)
    }
    
    
}
