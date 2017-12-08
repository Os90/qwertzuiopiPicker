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
        
//        DispatchQueue.main.async {
//            let closeButtonImage = UIImage(named: "icons8-left_4")
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(self.goBack))
//
//        }
//        urlWithForBestellung(url: "http://139.59.129.92/api/dummyorder") {(result : antwort) in
//            print(result)
//
//            if let myresult = result.objects{
//                self.ListBestellung = myresult
//                DispatchQueue.main.async {
//                    self.mytbl.reloadData()
//                }
//            }
////
//
//            let a = result.objects
//            self.WarenEingang?.objects = []
//            self.WarenEingang?.objects = a
//            if  self.WarenEingang?.objects?.count != 0{
//                print("hat geklappt")
//                self.ListBestellung = a!
//               // print(self.WarenEingang?.objects?.count)
//                //ListBestellung.append(Picklist.WarenEingang?.objects)
//                //self.ListBestellung = (Picklist.WarenEingang?.objects)!
//
//
//
//                //ListBestellung = (Picklist.WarenEingang?.objects)!
//            }
        //}
//
//      //  print(Picklist.WarenEingang)
//
//
//        if  Picklist.WarenEingang?.objects.count != 0{
//            print("hat geklappt")
//            print(Picklist.WarenEingang?.objects.count)
//            //ListBestellung.append(Picklist.WarenEingang?.objects)
//            ListBestellung = (Picklist.WarenEingang?.objects)!
//
//
//            //ListBestellung = (Picklist.WarenEingang?.objects)!
//        }
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
