//
//  WareneingagViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class WareneingagViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var input: UITextField!
    
    @IBOutlet weak var StatusImage: UIImageView!
    
    @IBOutlet weak var okButton: UIButton!
    
    
    @IBOutlet weak var weiterButtom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        okButton.isHidden = true
        //StatusImage.isHidden = true
        input.delegate = self
        //weiterButtom.isHidden = true
        input.keyboardType = UIKeyboardType.decimalPad
        input.setBottomBorder()
        
        self.StatusImage.alpha = 0.0
        self.weiterButtom.alpha = 0.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        okButton.isHidden = false
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        prüfenNUmmerUI()
        überPrüfenNummer(input.text!)
        input.resignFirstResponder()

        
        UIView.animate(withDuration: 1.5, animations: {
            
            
            self.StatusImage.alpha = 1.0
            self.weiterButtom.alpha = 1.0
        })
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nummer = textField.text else {
            return false
        }
        prüfenNUmmerUI()
        überPrüfenNummer(nummer)
        return true
    }

    
    func prüfenNUmmerUI(){
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }
    
    func überPrüfenNummer(_ nummer : String){
        print(nummer)
    }
    
    @IBAction func qrButtonAction(_ sender: Any) {
      prüfenNUmmerUI()
    }
    
}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
