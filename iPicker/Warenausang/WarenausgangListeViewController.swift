//
//  WarenausgangListeViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit
import AudioToolbox

class WarenausgangListeViewController: UIViewController {
    
    //https://github.com/TUNER88/iOSSystemSoundsLibrary
    
    let DonesystemSoundID: SystemSoundID = 1000
    
    var donArray : [Int] = []
    var wrongArrary : [Int] = []
    var count = 0
    //var myarray = ["1","2","3","4"]

    @IBOutlet weak var mytbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Abholen"
       mytbl.register(UINib(nibName: "WECell", bundle: nil), forCellReuseIdentifier: "Cell")
        let closeButtonImage = UIImage(named: "icons8-1_circle_filled")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(self.goBack))
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @objc func goBack()
    {
        // create the alert
        let alert = UIAlertController(title: "FERTIG!", message: "Alles Abgeholt", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ja, bin am WA \(2)", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "done", sender: self)
        }))
        //alert.addAction(UIAlertAction(title: "Nein, doch nicht", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Nein, doch nicht!", style: UIAlertActionStyle.destructive, handler: { action in
            
            // do something like...
            // self.launchMissile()
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WarenEingangTableViewCell
        
        cell.Ean.text = "asadfdsf"
        cell.menge.text = "10x"
        cell.Position.text = "yListe[indexPath.row].position"
        //cell.status.backgroundColor = UIColor(rgb: 0x395270)
        if donArray.contains(indexPath.row){
            cell.status.backgroundColor = UIColor(rgb: 0x395270)
            count = count + 1
        }else if wrongArrary.contains(indexPath.row){
            cell.status.backgroundColor = UIColor.red
            count = count + 1
        }
        else{
            cell.status.backgroundColor = UIColor.white
            cell.status.layer.borderWidth = 0.5
            cell.status.layer.borderColor = UIColor.black.cgColor
        }

        checkCount(count)
        return cell
    }
    
    func checkCount(_ anzahl : Int){
        if count == 2{
              self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 97.00
        
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Nicht OK", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Korrektur, marked as Closed")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.myAlert(indexPath)
            success(true)
        })

        closeAction.image = UIImage(named: "icons8-multiply-1")
        closeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func myAlert(_ index : IndexPath){
        // create the alert
        let alert = UIAlertController(title: "Nicht OK", message: "Ware nicht vorhanden, ja?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "JA!", style: UIAlertActionStyle.default, handler: { action in
            self.wrongArrary.append(index.row)
            self.mytbl.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Andere Gründe(nicht komplett,beschädigt usw..)", style: UIAlertActionStyle.destructive, handler: { action in
            
           self.wrongArrary.append(index.row)
             self.mytbl.reloadData()
            
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Richtig", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Richtig action ...")
            AudioServicesPlaySystemSound (self.DonesystemSoundID)
            self.donArray.append(indexPath.row)
            success(true)
            self.mytbl.reloadData()
        })
        modifyAction.image = UIImage(named: "icons8-checkmark_filled-1")
        modifyAction.backgroundColor = UIColor(rgb: 0x395270)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
}
