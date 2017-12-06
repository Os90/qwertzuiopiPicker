//
//  WarenausgangListeViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class WarenausgangListeViewController: UIViewController {

    @IBOutlet weak var mytbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       mytbl.register(UINib(nibName: "WECell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension WarenausgangListeViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WarenEingangTableViewCell
        
        cell.Ean.text = "1234567890"
        cell.menge.text = "2"
        cell.Position.text = "1234567890"
        cell.status.backgroundColor = UIColor.blue
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 97.00
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let favorite = UITableViewRowAction(style: .normal, title: "Nicht OK") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .red
        
        //        let share = UITableViewRowAction(style: .normal, title: "Ok") { action, index in
        //            print("share button tapped")
        //
        //        }
        //        share.backgroundColor = .green
        
        return [favorite]
    }
}
