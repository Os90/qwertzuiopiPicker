
//
//  PufferViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 02.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class PufferViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var myOkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputText.delegate = self
        
        inputText.setBottomBorder()
        
        inputText.keyboardType = UIKeyboardType.decimalPad
        
        myOkBtn.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        myOkBtn.isHidden = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    @IBAction func myOKBtnAction(_ sender: Any) {
        PufferNummerHochalden()
    }
    
    func PufferNummerHochalden(){
        
        let pufferNr = inputText.text!
        let bestellnr = 0
        
        let url = URL(string: "http://www.thisismylink.com/postName.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "bestellNr=\(bestellnr)&pufferNr=\(pufferNr)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        
        
    }
    
}

