//
//  OrderPopupController.swift
//  MagicFlowers
//
//  Created by Abraham Barcenas M on 4/18/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class OrderController: UITableViewController {
    
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var txtVComentarios: UITextView!
    @IBOutlet weak var txtNumTarjeta: UITextField!
    @IBOutlet weak var txtCodigoSeguridad: UITextField!
    @IBOutlet weak var txtFechaVencimiento: UITextField!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var stackPicker: UIStackView!
    
    var id: String!
    var nombre: String!
    var precio: String!
    var imagen: UIImage!
    var username: String!
    
    var years : [Int] = []
    var months : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFechaVencimiento.delegate = self
        datePicker.delegate = self
        datePicker.dataSource = self
        
        showProduct()
        getYearsForPicker()
        getMonthsForPicker()
    }
    
    func showProduct(){
        username = UserDefaults.standard.value(forKey: KEY_USERNAME) as! String
        imgProducto.image = imagen
        lblNombre.text = nombre
        lblPrecio.text = precio
        txtVComentarios.layer.borderColor = UIColor.lightGray.cgColor
        txtVComentarios.layer.borderWidth = 1.0
        txtVComentarios.layer.cornerRadius = 5.0
    }
    
    func getYearsForPicker() {
        let date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        year = Int(year)
        years.append(year)
        for _ in 0 ... 15 {
            year += 1
            years.append(year)
        }
    }
    
    func getMonthsForPicker() {
        for i in 1 ... 12 {
            months.append(i)
        }
    }
    
    func alert(title: String? = "", message: String? = ""){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmarPressed(_ sender: Any) {
        guard let numTarjeta = txtNumTarjeta.text, !numTarjeta.isEmpty, numTarjeta.characters.count > 7 else {
            alert(title: "Oops", message: "Verifique que el numero de tarjeta sea correcto")
            return
        }
        guard let codigoSeg = txtCodigoSeguridad.text, !codigoSeg.isEmpty, codigoSeg.characters.count == 3 else {
            alert(title: "Oops", message: "Verifique que el codigo de seguridad de la tarjeta sea correcto")
            return
        }
        guard let fechaVencimiento = txtFechaVencimiento.text, !fechaVencimiento.isEmpty else {
            alert(title: "Oops", message: "Verifique que el codigo de seguridad de la tarjeta sea correcto")
            return
        }
        
        if let notas = txtVComentarios.text {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            
            
            var orderDict :  [String : Any] = [:]
            orderDict["notes"] = notas
            orderDict["productId"] = id
            orderDict["registerDate"] = formatter.string(from: Date())
            orderDict["total"] = precio
            orderDict["username"] = username
            print(orderDict)
            DataService.ds.createNewOrder(user: username, orderData: orderDict)
            
            let alert = UIAlertController(title: "Exito", message: "Compra realizada con exito", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func CancelPickerPressed(_ sender: UIButton) {
        stackPicker.isHidden = true
    }
    
    @IBAction func DonePickerPressed(_ sender: UIButton) {
        let selectedDate = "\(months[datePicker.selectedRow(inComponent: 0)])/\(years[datePicker.selectedRow(inComponent: 1)])"
        txtFechaVencimiento.text = selectedDate
        stackPicker.isHidden = true
    }
}

extension OrderController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFechaVencimiento {
            stackPicker.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFechaVencimiento {
            stackPicker.isHidden = true
        }
    }
}

extension OrderController : UIPickerViewDelegate, UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return months.count
        }else{
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            let month = months[row]
            return "\(month)"
        }else{
            let year = years[row]
            return "\(year)"
        }
    }
    
    
    
}
