//
//  WarenausgangViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class WarenausgangViewController: UIViewController {
    var ListBestellung : [objects] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if userAlreadyExist(key: "session"){
            self.performSegue(withIdentifier: "ordernummer", sender: self)
        }

    }
    
    @objc func goBack()
    {
        if let navigationController = navigationController {
            //NotificationCenter.default.post(name:Notification.Name(GSNotifications.backToStart), object: nil, userInfo: nil)
            navigationController.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var objectToSend : objects?
        
        if segue.identifier == "ordernummer"{
            
            if userAlreadyExist(key: "session"){
                
                if let data = UserDefaults.standard.value(forKey:"struct") as? Data {
                    let songs2 = try? PropertyListDecoder().decode(objects.self, from: data)
                    Picklist.sessionObject = songs2
                }
                
                objectToSend =  Picklist.sessionObject
                
            }else{
                objectToSend = sender as? objects
            }
            
            Picklist.sessionObject = objectToSend
        }
    }
    
}
extension WarenausgangViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ListBestellung.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let text = ListBestellung[indexPath.row].bestellungsNr{
            cell.textLabel?.text = "Auftragsnummer : \(text)"
            cell.detailTextLabel?.text = "Seit 15 min..."
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Aufträge (0)"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObject = ListBestellung[indexPath.row]
        performSegue(withIdentifier: "ordernummer", sender: selectedObject)
    }
    
}
