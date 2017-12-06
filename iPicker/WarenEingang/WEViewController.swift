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
    
    var ListBestellung : [bestellung] = []
    var ListatIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
//            self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icons8-left_4")
//            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icons8-left_4")
//            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "sf", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//            let barbUtton =  UIBarButtonItem(barButtonSystemItem: ., target: self, action: #selector(self.goBack))
//            barBbarbUttonuttonItem.image = UIImage(named: "image")
//            self.navigationItem.leftBarButtonItem =
            
            
            let closeButtonImage = UIImage(named: "icons8-left_4")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(self.goBack))

        }
       urlWithForBestellung(url: "oajsdfoasdf")
        
        if Picklist.WarenEingang.count != 0{
            print("hat geklappt")
            ListBestellung = Picklist.WarenEingang
        }
        
    }

    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "liste"{
//            let destinationVC = segue.destination as! WareneingangListeViewController
//            destinationVC.myListe = ListBestellung[ListatIndex].liste
//        }
    }
}

extension WEViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return ListBestellung.count
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cell.textLabel?.text  = ListBestellung[indexPath.row].bestellungsNR
        
        cell.textLabel?.text  = "asdf"
        
        
        //cell.detailTextLabel?.text = "Seit 30 min"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ListatIndex = indexPath.row
         let cell = mytbl.cellForRow(at: indexPath)
            print(cell?.textLabel?.text)
            performSegue(withIdentifier: "liste", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bestellungen (\(ListBestellung.count))"
    }

}
