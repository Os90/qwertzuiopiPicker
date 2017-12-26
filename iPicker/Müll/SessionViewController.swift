//
//  SessionViewController.swift
//  iPicker
//
//  Created by Osman A on 20.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       print(Picklist.username)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func weiter(_ sender: Any) {
        
                if Picklist.sessionName == "bestellung"{
                    goToWareneingang()
                }
                else{
                    goToWarenausang()
                }
    }
    func goToWareneingang(){
        let storyboard = UIStoryboard(name: "Wareneingang", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "WarenEingang") as! WEViewController
        
        if let navigationController = navigationController {
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }
    func goToWarenausang(){
        let storyboard = UIStoryboard(name: "warenausgang", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "warenausgangCtrl") as! WarenausgangViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }
    
    func getData(){
        if let data = UserDefaults.standard.value(forKey:"struct") as? Data {
            let songs2 = try? PropertyListDecoder().decode(objects.self, from: data)
            Picklist.sessionObject = songs2
        }
    }

    
    @IBAction func abbruch(_ sender: Any) {
                getData()
                abbruchFunc(completion: { isSuccess in
                    if isSuccess{
                        self.sessionInitAll()
                        self.doneAlert()
                    }
                })
        
    }
    func abbruchFunc(completion: @escaping (_ wert : Bool) -> Void) {
       // guard let id = Picklist.sessionObject?._id else {return}
        guard let bid = Picklist.sessionObject?.bestellungsNr else {return}
        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/canceled")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let json: [String: Any] = ["mission_order_id": "\(bid)", "user": "OSMANTEST999999",]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                completion(false)
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            completion(true)
            return
        }
        task.resume()
    }

    
    @IBAction func wechsel(_ sender: Any) {
        getData()
        PostResultSession(urlString: "http://myBestURL.com", completion: { isSuccess in
            if isSuccess{
                self.sessionInitAll()
                self.doneAlert()
            }else{
                print("Kein Internet")
            }})
    }
    
    func PostResultSession(urlString: String, completion: @escaping (_ wert : Bool) -> Void) {
        Picklist.sessionObject?.status = "Nuter Wechsel"
        guard let id = Picklist.sessionObject?._id else {return}
        let myURL = "http://139.59.129.92/api/dummyorder/\(id)"
        let request = NSMutableURLRequest(url: NSURL(string: myURL)! as URL)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(Picklist.sessionObject)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                completion(false)
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            completion(true)
            return
        }
        task.resume()
    }
    
    func sessionInitAll(){
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:"session")
        prefs.removeObject(forKey:"was")
        prefs.removeObject(forKey:"struct")
        let empty : objects? = nil
        Picklist.sessionObject = empty
    }
    func doneAlert(){
        let alert = UIAlertController(title: "Es kann weiter gehen!!", message: "--",preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            alert.dismiss(animated: true, completion: {() -> Void in
                
                if let navigationController = self.navigationController {
                    //Picklist.durchlaufBestellungen = Picklist.durchlaufBestellungen + 1
                    navigationController.popToRootViewController(animated: true)
                }
            })
        })
    }
}
