//
//  WareneingangListeViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit
import AudioToolbox

class WareneingangListeViewController: UIViewController {
    //https://github.com/TUNER88/iOSSystemSoundsLibrary
    
    let DonesystemSoundID: SystemSoundID = 1000
    
    @IBOutlet weak var myImg: UIImageView!
    
    @IBOutlet weak var mytbl: UITableView!
    
    var timer = Timer()
    var startTime = TimeInterval()
    var myListe : [artikel] = []
    var subtitle = String()
    
    var myArray :[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mytbl.register(UINib(nibName: "WECell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        let aSelector : Selector = #selector(PickerViewController.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        addButon()
        initBestellungsAntwort()
        bestellugAntwort.bestellugArtikel = myListe
        bestellugAntwort.bestellugEnd_time = 13
        bestellugAntwort.bestellugStart_time = 10
    }
    
    
    func initBestellungsAntwort(){
        if bestellugAntwort.bestellugArtikel.count > 0 {
            bestellugAntwort.bestellugArtikel.removeAll()
        }
        bestellugAntwort.bestellugEnd_time = 0
        bestellugAntwort.bestellugStart_time = 0
    }

    
    @objc func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        var elapsedTime: TimeInterval = currentTime - startTime
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        subtitle = "\(strMinutes):\(strSeconds)"
        self.navigationItem.setTitle(title: "Positionieren", subtitle: subtitle)
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
        //self.navigationItem.title = "Positionieren"
        self.navigationItem.setTitle(title: "Positionen", subtitle: subtitle)
        self.navigationItem.setRightBarButtonItems([backBarButon], animated: false)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
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
    
    func arraySort(_ array : Array<Int>){
        let mySet = Set<Int>(array)
        myArray = Array(mySet) // [2, 4, 60, 6, 15, 24, 1]
    }
}

extension WareneingangListeViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bestellugAntwort.bestellugArtikel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WarenEingangTableViewCell
        if (indexPath.row % 2 == 0){
         cell.backgroundColor = UIColor(rgb: 0xEBEBEB)
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        if let ean = bestellugAntwort.bestellugArtikel[indexPath.row].ean{
            cell.Ean.text = String(ean)
        }
         if let menge = bestellugAntwort.bestellugArtikel[indexPath.row].menge{
         cell.menge.text = "\(menge)x"
        }
        if let pos = bestellugAntwort.bestellugArtikel[indexPath.row].position
        {
            cell.Position.text = pos
        }
        if myArray.contains(indexPath.row){
            if bestellugAntwort.bestellugArtikel[indexPath.row].belegt == 0 {
                cell.status.backgroundColor = UIColor.red
            }
            else{
                cell.status.backgroundColor = UIColor(rgb: 0x395270)
            }
        }
        else{
            cell.status.layer.borderWidth = 0.5
            cell.status.layer.borderColor = UIColor.black.cgColor
        }
        
        if myArray.count == bestellugAntwort.bestellugArtikel.count{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.00

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
        let alert = UIAlertController(title: "Nicht OK", message: "Position schon belegt, ja?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "JA!", style: UIAlertActionStyle.default, handler: { action in
            self.myArray.append(myindex.row)
            self.arraySort(self.myArray)
            bestellugAntwort.bestellugArtikel[myindex.row].belegt = 0
            self.mytbl.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Andere Gründe", style: UIAlertActionStyle.destructive, handler: { action in
            self.myArray.append(myindex.row)
            self.arraySort(self.myArray)
            bestellugAntwort.bestellugArtikel[myindex.row].belegt = 0
            self.mytbl.reloadData()
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Richtig", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Richtig action ...")
            AudioServicesPlaySystemSound (self.DonesystemSoundID)
            self.myArray.append(indexPath.row)
            self.arraySort(self.myArray)
            bestellugAntwort.bestellugArtikel[indexPath.row].belegt = 1
            success(true)
            self.mytbl.reloadData()
        })
        modifyAction.image = UIImage(named: "icons8-checkmark_filled-1")
        modifyAction.backgroundColor = UIColor(rgb: 0x395270)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
extension UINavigationItem {
    
    
    
    func setTitle(title:String, subtitle:String) {
        
        let one = UILabel()
        one.text = title
        one.font = UIFont.systemFont(ofSize: 17)
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.font = UIFont.systemFont(ofSize: 12)
        two.textAlignment = .center
        two.sizeToFit()
        
        
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        
        
        self.titleView = stackView
    }
}

