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
    var komplett  = true

    @IBOutlet weak var mytbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Abholen"
       mytbl.register(UINib(nibName: "WECell", bundle: nil), forCellReuseIdentifier: "Cell")
        let closeButtonImage = UIImage(named: "icons8-1_circle_filled")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(self.goBack))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(self.backAction))

        
        if self.navigationController?.interactivePopGestureRecognizer?.isEnabled != nil {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    @objc func backAction(){
        
        // create the alert
        let alert = UIAlertController(title: "Sicher?", message: "Sie würden damit die Sitzung löschen!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.default, handler: { action in
            self.saveSession()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        //alert.addAction(UIAlertAction(title: "Nein, doch nicht", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Nein, doch nicht!", style: UIAlertActionStyle.destructive, handler: { action in
            
            // do something like...
            // self.launchMissile()
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }

    @objc func goBack()
    {
        // create the alert
        let alert = UIAlertController(title: "FERTIG!", message: "Alles Abgeholt", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ja, bin am WA \(1)", style: UIAlertActionStyle.default, handler: { action in
            //PERFORM SEGUE
        }))
        //alert.addAction(UIAlertAction(title: "Nein, doch nicht", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Nein, doch nicht!", style: UIAlertActionStyle.destructive, handler: { action in
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkIfComplete(){
        if komplett{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    func saveSession(){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "session")
        defaults.set("auftrag", forKey: "was")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(Picklist.sessionObject), forKey:"struct")
    }

}
extension WarenausgangListeViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count  = Picklist.sessionObject?.artikel?.count{
            return count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WarenEingangTableViewCell
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(rgb: 0xEBEBEB)
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        if let ean = Picklist.sessionObject?.artikel![indexPath.row].ean{
            cell.Ean.text = String(ean)
        }
        if let menge = Picklist.sessionObject?.artikel![indexPath.row].menge{
            cell.menge.text = "\(menge)x"
        }
        if let pos = Picklist.sessionObject?.artikel![indexPath.row].position
        {
            cell.Position.text = pos
        }
        
        if let belegt = Picklist.sessionObject?.artikel![indexPath.row].belegt{
            if belegt == 0{
                cell.status.backgroundColor = UIColor.red
            }else if belegt == 1{
                cell.status.backgroundColor = UIColor(rgb: 0x395270)
            }
        }
        else{
            cell.status.layer.borderWidth = 0.5
            cell.status.layer.borderColor = UIColor.black.cgColor
            komplett = false
        }
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
    
    func myAlert(_ myindex : IndexPath){
        // create the alert
        let alert = UIAlertController(title: "Nicht OK", message: "Ware nicht vorhanden, ja?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "JA!", style: UIAlertActionStyle.default, handler: { action in
            if let _ = Picklist.sessionObject?.artikel![myindex.row].belegt{
                //"ware nicht vorhanden"
                Picklist.sessionObject?.artikel![myindex.row].belegt = 0
            }
            self.mytbl.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Andere Gründe(nicht komplett,beschädigt usw..)", style: UIAlertActionStyle.destructive, handler: { action in
            
            if let _ = Picklist.sessionObject?.artikel![myindex.row].belegt{
                //"andere Gründe"
                Picklist.sessionObject?.artikel![myindex.row].belegt = 0
            }
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
            if let _ = Picklist.sessionObject?.artikel![indexPath.row].belegt{
                Picklist.sessionObject?.artikel![indexPath.row].belegt = 1
            }
            success(true)
            self.mytbl.reloadData()
        })
        modifyAction.image = UIImage(named: "icons8-checkmark_filled-1")
        modifyAction.backgroundColor = UIColor(rgb: 0x395270)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            checkIfComplete()
        }
    }
    
}
