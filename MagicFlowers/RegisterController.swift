//
//  RegisterController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 3/11/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUsuario.delegate = self
        txtPassword.delegate = self
        txtUsuario.rightViewMode = .always
        registerButton.isEnabled = false
        registerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        if let password = txtPassword.text, !password.isEmpty, let username = txtUsuario.text{
            let userData = ["password" : password]
            DataService.ds.createFirebaseDBUser(user: username, userData: userData)
            performSegue(withIdentifier: "registerToMain", sender: nil)
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion:  nil)
    }
    
    
}
extension RegisterController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == txtUsuario, let username = textField.text, username.rangeOfCharacter(from: WHITESPACE) == nil, !username.isEmpty{
            DataService.ds.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.hasChild(username){
                    print("NewUsername")
                    self.placeTextFieldRightImage(image: #imageLiteral(resourceName: "check"), color: #colorLiteral(red: 0.2222073078, green: 0.6842822433, blue: 0.3299767971, alpha: 1))
                    self.registerButton.isEnabled = true
                    self.registerButton.backgroundColor = #colorLiteral(red: 0.2040559649, green: 0.7372421622, blue: 0.6007294059, alpha: 1)
                    
                }else{
                    print("Username in Use")
                    self.placeTextFieldRightImage(image: #imageLiteral(resourceName: "cross"), color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                    self.registerButton.isEnabled = false
                    self.registerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            })
        }else{
            self.placeTextFieldRightImage(image: #imageLiteral(resourceName: "cross"), color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
            self.registerButton.isEnabled = false
            self.registerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    func placeTextFieldRightImage(image: UIImage, color: UIColor){
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        let imageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 20, height: 20))
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        txtUsuario.rightView = containerView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
