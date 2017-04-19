//
//  LoginController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/11/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUsuario.delegate = self
        txtPassword.delegate = self
        
    }
 
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let user = txtUsuario.text, !user.isEmpty, let password = txtPassword.text, !password.isEmpty{
            DataService.ds.REF_USERS.child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("password"){
                    if let userDict = snapshot.value as? [String : Any]{
                        if let pass = userDict["password"] as? String{
                            if pass == password{
                                UserDefaults.standard.set(user, forKey: KEY_USERNAME)
                                self.performSegue(withIdentifier: "loginToMain", sender: nil)
                            }else{
                                self.alertMessage(title: "Contraseña incorrecta", message: "La contraseña para el usuario ingresado es incorrecta")
                            }
                        }
                    }
                }else{
                    self.alertMessage(title: "Usuario no registrado", message: "El usuario ingresado no esta registrado")
                }
            })
                
        }else{
            alertMessage(title: "Oops", message: "Parece que olvido llenar uno de los campos")
        }
    }
    
    func alertMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    

}

extension LoginController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

