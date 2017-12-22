//
//  LagerDetailViewController.swift
//  iPicker
//
//  Created by Osman A on 21.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class LagerDetailViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var neuePosition = ""
    
    @IBOutlet weak var mytbl: UITableView!
    
    var artikelReceeive : [artikel] = []
    var nummer : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButtonImage = UIImage(named: "icons8-circled_chevron_right_filled-1")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(self.goForward))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        indicator.alpha = 0.0
    }

    @objc func goForward()
    {
        // create the alert
        let alert = UIAlertController(title: "FERTIG!", message: "UPDATEN", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.default, handler: { action in
            self.updateComplete()
            self.mytbl.alpha = 0.0
            self.indicator.alpha = 1.0
            self.indicator.startAnimating()
        }))
        //alert.addAction(UIAlertAction(title: "Nein, doch nicht", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Nein, doch nicht!", style: UIAlertActionStyle.destructive, handler: { action in
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    func updateComplete(){
        
        
        
        
    }
    @IBAction func statusChanged(_ sender: Any) {
        changedStatus(completion: { isSuccess in
            if isSuccess{
                self.doneAlert()
            }
            else{
                print("ERRROR")
            }
        })
        
    }
    func doneAlert(){
        let alert = UIAlertController(title: "Status auf 'Wareneingang' gewechselt", message: "Super 😀",preferredStyle: UIAlertControllerStyle.alert)
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
    func changedStatus(completion: @escaping (_ wert : Bool) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/dummyorder/\(nummer)")! as URL)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let json: [String: Any] = ["status": "WE"]
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension LagerDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return artikelReceeive.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let ean = artikelReceeive[indexPath.row].ean{
            cell.textLabel?.text = String(describing: ean)
        }
        if let comment = artikelReceeive[indexPath.row].comment{
            cell.detailTextLabel?.text = String(describing: comment)
            
            if comment == "OK"{
                cell.backgroundColor = UIColor(rgb: 0x395270)
                cell.textLabel?.textColor = UIColor.white
                cell.detailTextLabel?.textColor = UIColor.white
                cell.isUserInteractionEnabled = false
            }else{
                cell.backgroundColor = UIColor.white
                cell.textLabel?.textColor = UIColor(rgb: 0x395270)
                cell.detailTextLabel?.textColor = UIColor(rgb: 0x395270)
                cell.isUserInteractionEnabled = true
            }
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //0 steht für FALSCH
        if artikelReceeive[indexPath.row].belegt == 0 {
         alert(indexPath)
        }
    }
    
    func alert(_ myindex : IndexPath){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.neuePosition = (textField?.text)!
            self.artikelReceeive[myindex.row].position = (textField?.text)!
            self.artikelReceeive[myindex.row].belegt = 1
             self.artikelReceeive[myindex.row].comment = "OK"
            self.mytbl.reloadData()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        var ja = false
        if indexPath.row == lastRowIndex - 1 {
            for index in artikelReceeive{
                if index.belegt == 0{
                    ja   = true
                    break
                }
            }
            if !ja{
                checkIfComplete()
            }
        }
    }
    func checkIfComplete(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Artikeln (\(artikelReceeive.count))"
    }
    
    
    
}
