//
//  SeocondViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 07.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class SeocondViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var eingabe: UITextField!
    
    @IBOutlet weak var eingabeLabel: UILabel!
    
    
    @IBOutlet weak var position: UILabel!
    
    @IBOutlet weak var bestellung: UILabel!
    
    @IBOutlet weak var done: UIImageView!
    
    var index = 0
    @IBOutlet weak var okButton: UIButton!
    
    var positionVar = ""
    var bestellungVar = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let logo = UIImage(named: "icons8-barcode_scanner_2_filled")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        eingabe.delegate = self
        eingabe.keyboardType = .namePhonePad
        
        eingabe.becomeFirstResponder()
        done.isHidden = true
        
        status.text = "1/2"
        eingabeLabel.text = "Position Eingabe"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel(){
        status.text = "2/2"
        eingabeLabel.text = "Bestellung Eingabe"
    }

    func geheWeiter(){

        performSegue(withIdentifier: "ok", sender: self)
    }
    
    @IBAction func okAction(_ sender: Any) {

        if index == 0{
            positionVar =  eingabe.text!
            position.text = positionVar
            updateLabel()
            eingabe.text = ""
        }
        else if index == 1{
            bestellungVar =  eingabe.text!
            bestellung.text = bestellungVar
            eingabe.text = ""
            status.text = "FERTIG"
            eingabeLabel.text = "auf OK Drücken"
            done.isHidden = false
            eingabe.isHidden = true
        }
        else if index == 2{
              geheWeiter()
        }

        index = index + 1
    }
    
    
}
extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
