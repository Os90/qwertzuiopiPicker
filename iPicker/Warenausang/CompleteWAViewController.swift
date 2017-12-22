//
//  CompleteWAViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 07.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class CompleteWAViewController: UIViewController {
    
    @IBOutlet weak var erfolgreichView: UIView!
    @IBOutlet weak var nichterfolgreichView: UIView!
    @IBOutlet weak var halleView: UIView!
    
    @IBOutlet weak var erfolgreich: UILabel!
    @IBOutlet weak var nichtErfolgreich: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    var richtig = 0
    var falsch = 0
    
    var myartikel : [artikel] = []
    
    @IBOutlet weak var okbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        //self.navigationItem.setTitle(title: "Auftrags Nummer", subtitle: "\(1235)")
        erfolgreichView.getCorner(erfolgreichView)
        nichterfolgreichView.getCorner(nichterfolgreichView)
        halleView.getCorner(halleView)
        
        
        if let nummer = Picklist.sessionObject?.bestellungsNr{
            self.navigationItem.setTitle(title: "Bestellungsnummer", subtitle: "\(String(describing: nummer))")
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
        initComplete()
        UIView.animate(withDuration: 1.5, animations: {
            self.halleView.alpha = 1.0
        })
        erfolgreichView.getCorner(erfolgreichView)
        nichterfolgreichView.getCorner(nichterfolgreichView)
       // Picklist.sessionObject?.status = "an der Halle X"
    }
    
    func initComplete(){
        time.text  = "Dauer : \(Picklist.sessionObject?.start_time)"
        
        filter()
    }
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
    func saveResultToServer(){
        
        
        if falsch > 0{
            Picklist.sessionObject?.comment = "nicht komplett"
            Picklist.sessionObject?.complete = false
        }
        else{
            Picklist.sessionObject?.comment = "komplett"
            Picklist.sessionObject?.complete = true
        }
        
        Picklist.sessionObject?.status = "am Position"
        PostResultSession(urlString: "http://myBestURL.com", completion: { isSuccess in
            if isSuccess{
                self.sessionInitAll()
                self.doneAlert()
            }else{
                print("Kein Internet")
            }})
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
    
    func filter(){
        
        for index in myartikel{
            
            if index.belegt == 0{
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func okBtnAction(_ sender: Any) {
        
        if let navigationController = navigationController {
            saveResultToServer()
        }
        
//        Picklist.durchlaufAuftrage = Picklist.durchlaufAuftrage + 1
//        navigationController?.popToRootViewController(animated: true)
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
    
    @IBAction func cancelBtn(_ sender: Any) {
        let Snummer = Picklist.sessionObject?.bestellungsNr
        let Susername = Picklist.username
        cancelSession(wer: Susername!, nummer: Snummer!)
    }
    
    func cancelSession(wer : String, nummer: Int){
        
    }
    
}

extension UIView{
    
    func getCorner(_ myview : UIView){
        myview.layer.cornerRadius = 10.0
        myview.layer.shadowColor = UIColor.gray.cgColor
        myview.layer.masksToBounds = false
        myview.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        myview.layer.shadowOpacity = 1.0
        myview.layer.shadowRadius = 5
    }
}
