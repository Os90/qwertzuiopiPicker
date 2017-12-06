//
//  WareneingangListeViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class WareneingangListeViewController: UIViewController {
    
    @IBOutlet weak var mytbl: UITableView!
    
    var myListe : [liste] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButon()
       mytbl.register(UINib(nibName: "WECell", bundle: nil), forCellReuseIdentifier: "Cell")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addButon(){
        let btnleft : UIButton = UIButton(frame: CGRect(x:0, y:0, width:35, height:35))
        btnleft.setTitleColor(UIColor.white, for: .normal)
        btnleft.contentMode = .right
        
        btnleft.setImage(UIImage(named :"icons8-checkmark_filled-1"), for: .normal)
        btnleft.addTarget(self, action: #selector(WareneingangListeViewController.Fertig), for: .touchDown)
        let backBarButon: UIBarButtonItem = UIBarButtonItem(customView: btnleft)
        //self.navigationItem.setLeftBarButtonItems([backBarButon], animated: false)
        self.navigationItem.title = "Positionieren"
        self.navigationItem.setRightBarButtonItems([backBarButon], animated: false)
    }
    
    
    @objc func Fertig() {
        
        let refreshAlert = UIAlertController(title: "Fertig!", message: "Sind sie sich Sicher?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Nein, doch nicht!", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
}

extension WareneingangListeViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WarenEingangTableViewCell
        
        cell.Ean.text = String(describing: myListe[indexPath.row].ean)
        cell.menge.text = String(describing: myListe[indexPath.row].menge)
        cell.Position.text = myListe[indexPath.row].position
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



