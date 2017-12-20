//
//  AuthViewController.swift
//  Picker
//
//  Created by Osman Ashraf on 08/02/2017.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController,UITextFieldDelegate  {
    //URLS
    private let sendURL: String = "http://datacol-dev.ges.thm.de/API/MSRSendData"
    private let receiveURL: String = "http://datacol-dev.ges.thm.de/API/MSRGetData"
    
    @IBOutlet weak var number1: UITextField!
    
    @IBOutlet weak var number2: UITextField!
    
    @IBOutlet weak var number3: UITextField!
    
    @IBOutlet weak var number4: UITextField!
    
    var name = String()
    
    var loginSucess = Bool()
    
    //Server
    var myArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        number1.delegate = self
        number2.delegate = self
        self.number3.delegate = self
        self.number4.delegate = self
        
        self.number1.keyboardType = UIKeyboardType.numberPad
        self.number2.keyboardType = UIKeyboardType.numberPad
        self.number3.keyboardType = UIKeyboardType.numberPad
        self.number4.keyboardType = UIKeyboardType.numberPad
        
        number1.addTarget(self, action:#selector(self.a(textField:)), for: UIControlEvents.editingChanged)
        number2.addTarget(self, action:#selector(self.a(textField:)), for: UIControlEvents.editingChanged)
        self.number3.addTarget(self, action:#selector(self.a(textField:)), for: UIControlEvents.editingChanged)
        self.number4.addTarget(self, action:#selector(self.back2Page), for: UIControlEvents.editingChanged)
        
        
        self.number1.becomeFirstResponder()
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func a(textField: UITextField){
        
        print("changed")
        
        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case  self.number1:
                self.number2.becomeFirstResponder()
            case  self.number2:
                self.number3.becomeFirstResponder()
            case  self.number3:
                self.number4.becomeFirstResponder()
            case  self.number4:
                self.number4.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
    }
    
    @objc func back2Page(){
        
        if überprüfen(){
            print("richtig!")
            view.endEditing(true)
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(name, forKey: "login")
            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            let alertView = UIAlertController(title: "Falsche Eingabe", message: "Bitte wiederholen Sie den vorgang", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction (title: "Ok", style: .cancel ) {  alertAction in
                self.number1.becomeFirstResponder()
            }
            self.present(alertView, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.number1.text = ""
                self.number2.text = ""
                self.number3.text = ""
                self.number4.text = ""
            }
            alertView.addAction(cancelAction)
        }
    }
    
    func überprüfen()->Bool{
        myArray.removeAll()
        
        myArray.append(self.number1.text!)
        myArray.append(self.number2.text!)
        myArray.append(self.number3.text!)
        myArray.append(self.number4.text!)
        
        print(myArray)
        //loginServer()
        loginSucess = true
        return loginSucess
    }
    
    
    func loginServer(){
        guard let url = NSURL(string: sendURL) else {
            print("Error: cannot create URL")
            return
        }
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var values: [String: AnyObject] = [:]
        values["pw"] = myArray as AnyObject?
        //values["date"] = "05-12-2016" as AnyObject?
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        
        myArray.removeAll()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error)
                //print("error calling POST on " + self.sendURL)
                //print(error)
                DispatchQueue.main.async {
                    self.loginSucess = false
                }
                return
            }
            // make sure we got data
            guard let responseData = data else {
                self.loginSucess = false
                print("Error: did not receive data")
                return
            }
            do {
                
                let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject]
                // print("jajaja")
                print("jsonobject \(jsonObject)")
                
                self.loginSucess = true
                self.name = String(describing: jsonObject)
                
            }
            catch let error as NSError {
                print(error)
            }
            
        })
        task.resume()
        
    }
    
    
    @IBAction func codeErhalten(_ sender: Any) {
        print("kein code erhalten")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.number1.becomeFirstResponder()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue")
        if (segue.identifier == "login") {
            // initialize new view controller and cast it as your view controller
            //let viewController = segue.destination as! PickListeViewController
            // your new view controller should have property that will store passed value
            //            print(valueToPass)
            //viewController.getValuePass = String(valueToPass)
        }
    }
    
    
}
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true;
//    }
//}
extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
}

