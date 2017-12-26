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

    var komplett  = true
    let DonesystemSoundID: SystemSoundID = 1000
    
    @IBOutlet weak var myImg: UIImageView!
    
    @IBOutlet weak var mytbl: UITableView!
    
    var timer = Timer()
    var startTime = TimeInterval()
    var subtitle = String()
    
    var artikelwithOk : [artikel] = []
    var tmpObject : [artikel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(self.backAction))
        mytbl.register(UINib(nibName: "WECell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        let aSelector : Selector = #selector(PickerViewController.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        addButon()
        if userAlreadyExist(key: "session"){
            filterByOk()
        }else{
           ChechIN()
        }
        
    }    
    func updateStatus1(){
                updateStatus(completion: { isSuccess in
                    if isSuccess{
                       self.filterByOk()
                    }
                    else{
                        print("kein Internet")
                    }
                })
    }
    
    func filterByOk(){
        
        for index in (Picklist.sessionObject?.artikel)!{
            
            if index.comment == "OK"{
                if index.pickerID != Int(Picklist.username!){
                    artikelwithOk.append(index)
                }else{
                     tmpObject.append(index)
                }
            }else{
                 tmpObject.append(index)
            }
        }
        Picklist.sessionObject?.artikel?.removeAll()
        Picklist.sessionObject?.artikel  = tmpObject
        DispatchQueue.main.async {
           self.mytbl.reloadData()
        }
        
    }
    
    func ChechIN(){
        guard let id = Picklist.sessionObject?._id else {return}
        let longString = "http://139.59.129.92/api/dummyorder/\(id)"
        let urlString = longString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        urlforCheck(url: urlString!) {(result : objects) in
            if result.status == "WE"{
                self.updateStatus1()
            }else{
                 self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func urlforCheck(url: String, completion: @escaping (_ result: objects) -> Void) {
        let jsonUrlString = url
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let data = data else {return}
            do{
                let webSiteDesc = try JSONDecoder().decode(objects.self, from: data)
                completion(webSiteDesc)
            }catch let jsonErr{
                print(jsonErr)
            }
            
            }.resume()
        
    }
    
    
    func updateStatus(completion: @escaping (_ wert : Bool) -> Void) {
        guard let id = Picklist.sessionObject?._id else {return}
        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/dummyorder/\(id)")! as URL)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // let encoder = JSONEncoder()
        do{
            let json: [String: Any] = ["status": "IN BEARBEITUNG"]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                completion(false)
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            completion(true)
            return
        }
        task.resume()
    }
    func checkIfComplete(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
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
    func saveSession(){
        for index in artikelwithOk{
            Picklist.sessionObject?.artikel?.append(index)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "session")
        defaults.set("bestellung", forKey: "was")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(Picklist.sessionObject), forKey:"struct")
    }

    
    func timestamp()->String{
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        print(formatter.string(from: date as Date))
        return formatter.string(from: date as Date)
    }
    
    func initBestellungsAntwort(){
        if bestellugAntwort.bestellugArtikel.count > 0 {
            bestellugAntwort.bestellugArtikel.removeAll()
        }
//        bestellugAntwort.bestellugEnd_time = 0
//        bestellugAntwort.bestellugStart_time = 0
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ok"{
            
            for i in 0 ... (Picklist.sessionObject?.artikel?.count)!{
                
                Picklist.sessionObject?.artikel?[i].pickerID = Int(Picklist.username!)
            }
            
            tmpObject = (Picklist.sessionObject?.artikel)!
            
            for index in artikelwithOk{
                Picklist.sessionObject?.artikel?.append(index)
            }
            let destinationVC = segue.destination as! CompleteWEViewController
            destinationVC.myartikel = tmpObject
        }
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
            self.performSegue(withIdentifier: "ok", sender: self)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Nein, doch nicht!", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
//    func arraySort(_ array : Array<Int>){
//        let mySet = Set<Int>(array)
//        myArray = Array(mySet) // [2, 4, 60, 6, 15, 24, 1]
//    }
}

extension WareneingangListeViewController: UITableViewDelegate,UITableViewDataSource{
    
    
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
            Picklist.sessionObject?.artikel![myindex.row].belegt = 0
            Picklist.sessionObject?.artikel![myindex.row].comment = "Position schon belegt"
            Picklist.sessionObject?.artikel![myindex.row].pickerID = Int(Picklist.username!)
            //Picklist.username

            self.mytbl.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Andere Gruende", style: UIAlertActionStyle.destructive, handler: { action in
            Picklist.sessionObject?.artikel![myindex.row].belegt = 0
            Picklist.sessionObject?.artikel![myindex.row].comment = "Andere Gründe"
            Picklist.sessionObject?.artikel![myindex.row].pickerID = Int(Picklist.username!)
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
            Picklist.sessionObject?.artikel![indexPath.row].belegt = 1
            Picklist.sessionObject?.artikel![indexPath.row].comment = "OK"
            Picklist.sessionObject?.artikel![indexPath.row].pickerID = Int(Picklist.username!)
            
            success(true)
            self.mytbl.reloadData()
        })
        modifyAction.image = UIImage(named: "icons8-checkmark_filled-1")
        modifyAction.backgroundColor = UIColor(rgb: 0x395270)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        var ja = false
        if indexPath.row == lastRowIndex - 1 {
            for index in (Picklist.sessionObject?.artikel)!{
                if index.belegt == nil{
                    ja   = true
                    break
                }
            }
            if !ja{
                 checkIfComplete()
            } 
        }
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

