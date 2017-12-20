//
//  CompleteWEViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 08.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class CompleteWEViewController: UIViewController {
    
    
    @IBOutlet weak var erfolgreichView: UIView!
    @IBOutlet weak var nichterfolgreichView: UIView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var doneImage: UIImageView!
    @IBOutlet weak var erfolgreich: UILabel!
    @IBOutlet weak var nichtErfolgreich: UILabel!
    
    @IBOutlet weak var OkBtn: UIButton!
    
    @IBOutlet weak var abbrechenBtn: UIButton!
    
    var richtig = 0
    var falsch = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nummer = Picklist.sessionObject?.bestellungsNr{
            self.navigationItem.setTitle(title: "Bestellungsnummer", subtitle: "\(String(describing: nummer))")
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
        initComplete()
        UIView.animate(withDuration: 1.5, animations: {
            self.doneImage.alpha = 1.0
        })
        erfolgreichView.getCorner(erfolgreichView)
        nichterfolgreichView.getCorner(nichterfolgreichView)
        Picklist.sessionObject?.status = "am Position"
    }

    func initComplete(){
        time.text  = "Dauer : \(Picklist.sessionObject?.start_time)"
        
        filter()
        }
    
    func filter(){
        
        for i in 0 ... (Picklist.sessionObject?.artikel?.count)! - 1 {
            
            if Picklist.sessionObject?.artikel?[i].belegt == 0{
                falsch = falsch + 1
            }
            else{
                richtig = richtig + 1
            }
            
        }
        erfolgreich.text = String(richtig)
        nichtErfolgreich.text = String(falsch)
        
        Picklist.sessionObject?.status = "am Position"
        
    }
    func sessionInitAll(){
        let prefs = UserDefaults.standard
        //keyValue = prefs.string(forKey:"TESTKEY")
        prefs.removeObject(forKey:"session")
        prefs.removeObject(forKey:"was")
        prefs.removeObject(forKey:"struct")
        let empty : objects? = nil
        Picklist.sessionObject = empty
    }
    
    
//    func test(completion: @escaping (_ wert : Bool) -> Void) {
//
//        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/dummyorder/1")! as URL)
//        request.httpMethod = "PATCH"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let encoder = JSONEncoder()
//        do{
//            let json: [String: Any] = ["status": "OSMAAAAAN"]
//            let jsonData = try? JSONSerialization.data(withJSONObject: json)
//            request.httpBody = jsonData
//            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
//        } catch {
//            print("ERROR")
//        }
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//
//            if error != nil {
//                print("error=\(String(describing: error))")
//                completion(false)
//                return
//            }
//
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("responseString = \(String(describing: responseString))")
//            completion(true)
//            return
//        }
//        task.resume()
//    }
    
    func PostResultSession(urlString: String, completion: @escaping (_ wert : Bool) -> Void) {
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
    
    func postIFWrong(){
        guard let id = Picklist.sessionObject?._id else {return}
        let myURL = "http://139.59.129.92/api/dummyorder/\(id)"
        let request = NSMutableURLRequest(url: NSURL(string: myURL)! as URL)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do{
            let json: [String: Any] = ["_updated": "nicht komplett"]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                //completion(false)
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            //completion(true)
            return
        }
        task.resume()
    }
    
    
    func saveResultToServer(){
        
        if falsch > 0{
            postIFWrong()
        }

        PostResultSession(urlString: "http://myBestURL.com", completion: { isSuccess in
            if isSuccess{
                self.sessionInitAll()
                self.doneAlert()
            }else{
                print("Kein Internet")
            }})
    }

    @IBAction func bestätigen(_ sender: Any) {
        
        
        if let navigationController = navigationController {
            saveResultToServer()
        }
    }
    
    func doneAlert(){
        let alert = UIAlertController(title: "Bestellung auf Position", message: "Super 😀",preferredStyle: UIAlertControllerStyle.alert)
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
    @IBAction func abbrechenAction(_ sender: Any) {
        let Snummer = Picklist.sessionObject?.bestellungsNr
        let Susername = Picklist.username
        cancelSession(wer: Susername, nummer: Snummer!)
    }
    
    func cancelSession(wer : String, nummer: Int){
        
    }
    
    @IBOutlet weak var abbrechenAction: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
