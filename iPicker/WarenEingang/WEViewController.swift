//
//  WEViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 02.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class WEViewController: UIViewController {

    @IBOutlet weak var mytbl: UITableView!
    var WarenEingang : antwort?
    var ListBestellung : [objects] = []
    var bestellungsNrTitle = String()
    var ListatIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userAlreadyExist(key: "session"){
            
            self.performSegue(withIdentifier: "liste", sender: self)
        }
    }
    func userAlreadyExist(key : String) -> Bool {
        return UserDefaults.standard.object(forKey:key) != nil
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
        if segue.identifier == "liste"{
            self.navigationItem.title = String(ListBestellung[ListatIndex].bestellungsNr!)
            let destinationVC = segue.destination as! WareneingangListeViewController
            destinationVC.myListe = ListBestellung[ListatIndex].artikel!
            bestellugAntwort.bestellungsNr = ListBestellung[ListatIndex].bestellungsNr!
        }
    }
}

extension WEViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return ListBestellung.count
        return ListBestellung.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let text = ListBestellung[indexPath.row].bestellungsNr{
            cell.textLabel?.text = "Bestellungsnummer : \(text)"
             cell.detailTextLabel?.text = "Seit 15 min..."
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ListatIndex = indexPath.row
        let cell = mytbl.cellForRow(at: indexPath)
        bestellungsNrTitle = String(describing: ListBestellung[indexPath.row].bestellungsNr)
        performSegue(withIdentifier: "liste", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bestellungen (\(ListBestellung.count))"
    }

}
