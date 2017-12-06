//
//  NachScannenInventurViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 23.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class NachScannenInventurViewController: UIViewController {
    
    
    @IBOutlet weak var mytbl: UITableView!
    
    @IBOutlet weak var total: UILabel!
    
    var myArrayFrom:[Picklist] = []
    
    @IBOutlet weak var abschlißen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytbl.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "Cell")
        myArrayFrom = Picklist.myArray
        total.text = "Ingesamt Ware \(myArrayFrom.count)"
        if myArrayFrom.count == 0 {
            abschlißen.isEnabled = false
        }
        else{
            abschlißen.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func abschließenAction(_ sender: Any) {
        
        asdfdf()
    }
    
    func asdfdf(){
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.178.24/neu/index.php")! as URL)
        request.httpMethod = "POST"

//                let myID = Picklist.init(id: 3, ean: "asdf", position: "q", time: "asdf", menge: 4)
//                let myID1 = Picklist.init(id: 24, ean: "22324q324", position: "qasdfasdfasdf", time: "asdfasfdasfsdf", menge: 4)
//
//                Picklist.myArray.append(myID)
//                Picklist.myArray.append(myID1)
                let encoder = JSONEncoder()
        do{
                    let jsonData = try encoder.encode(Picklist.myArray)
                    //let jsonString = String(data: jsonData, encoding: .utf8)
                    request.httpBody = jsonData
                    print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
                } catch {
                    print("ERROR")
                }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            Picklist.myArray.removeAll()
        }
        task.resume()
    }
    
    
//    let string = "[{\"form_id\":3465,\"canonical_name\":\"df_SAWERQ\",\"form_name\":\"Activity 4 with Images\",\"form_desc\":null}]"
//    let data = string.data(using: .utf8)!
//    do {
//    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
//    {
//
//    } else {
//    print("bad json")
//    }
//    } catch let error as NSError {
//    print(error)
//    }
   
}

extension NachScannenInventurViewController: UITableViewDataSource,UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArrayFrom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PickerTableViewCell
        cell.CountLabel.text = String(myArrayFrom[indexPath.row].menge)
        cell.EanLabel.text = myArrayFrom[indexPath.row].ean
        cell.PositionLabel.text = myArrayFrom[indexPath.row].position
        cell.StatusImg.image = UIImage(named: "icons8-checkmark_filled")
        cell.editImage.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120.0
    }
}
