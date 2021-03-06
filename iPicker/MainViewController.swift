//
//  MainViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 08.11.2017.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var bestellungsBild: UIImageView!
    @IBOutlet weak var inventurBild: UIImageView!
    @IBOutlet weak var picklisteBild: UIImageView!
    @IBOutlet weak var auftragBild: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var LastView: UIView!
    @IBOutlet weak var firstViewBadge: UILabel!
    @IBOutlet var secondViewLabel: UIView!
    @IBOutlet var thirdVuewLabel: UIView!
    @IBOutlet weak var lastBadge: UILabel!
    @IBOutlet weak var sessionBtn: UIButton!
    @IBOutlet weak var sessionView: UIView!
    
    @IBOutlet weak var sessionImage: UIImageView!
    
    var eingeloggt = false
    
    var aufträge = 0
    
    var bestellungsAntwort : antwort?
    var auftragsAntwort : antwort?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAllView()
        addGesture()
        checkUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         rechtsOben()
    }
    
    func rechtsOben(){
        var id = 0
        let userDefults = UserDefaults.standard
        if let highScore = userDefults.value(forKey: "status"){
            id = highScore as! Int
        }
        
        var name = ""
        switch id {
        case 1:
            name = "icons8-porridge_filled-2"
            break
        case 2:
            name = "icons8-sleep_filled-2"
            break
        case 3:
            name = "icons8-logout_rounded_up_filled"
            break
        case 4:
            name = "icons8-worker_filled-2"
            break
        default:
            break
        }
        
        
        let logOutButton = UIImage(named: name)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: logOutButton, style: .plain, target: self,   action:  #selector(self.goChangedStatus))
      
        
        
    }
        
        
    func checkUser(){
        
        if userAlreadyExist(key: "login") == false {
            self.performSegue(withIdentifier: "login", sender: self)
        }
        else{
           // Picklist.username = UserDefaults.standard.object(forKey:"login") as! String
            Picklist.username = "Osman"
            self.eingeloggt = true
            //username
            self.loginLabel.text = "Osman Ashraf"
            if Picklist.UserLagerChef.contains(Picklist.username!){
               lagerChefView(darf: true)
            }else{
                lagerChefView(darf: false)
            }
        }
    }
    
    func alleBestellungen(){
        let longString = """
        http://139.59.129.92/api/dummyorder?q={"filters":[{"name":"status","op":"eq","val":"WE"}]}
        """
        let urlString = longString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        urlWithForBestellung(url: urlString!) {(result : antwort) in
            self.bestellungsAntwort = result
            guard let count = result.objects?.count else {return}
            DispatchQueue.main.async {
                self.firstViewBadge.text = String(count)
            }
        }
    }
    func alleAufträge(){
        let longString = """
        http://139.59.129.92/api/dummyorder?q={"filters":[{"name":"status","op":"eq","val":"WA"}]}
        """
        let urlString = longString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        urlWithForBestellung(url: urlString!) {(result : antwort) in
            print(result)
            self.auftragsAntwort = result
            if let myresult = result.objects{
                DispatchQueue.main.async {
                    //let a = myresult.count - Picklist.durchlaufBestellungen
                    self.lastBadge.text =  String(myresult.count)
                }
            }
        }
    }
    
    
    @IBAction func sessionAction(_ sender: Any) {
        goToSesion()
    }
    
    func goToSesion(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
            self.checkUser()
            self.checkLastSession()
            self.alleBestellungen()
            self.alleAufträge()
    }
    
    func checkLastSession(){
        if self.userAlreadyExist(key: "session"){
            let dafaults = UserDefaults.standard
            if let was = dafaults.object(forKey: "was"){
                switch(String(describing: was)){
                case "bestellung":
                    print("bestellung")
                    Picklist.sessionName = "bestellung"
                    break
                case "auftrag":
                    print("auftrag")
                    Picklist.sessionName = "auftrag"
                    break
                default:
                    break
                }
            }
            sessionBtn.isHidden = false
            sessionImage.isHidden = false
            makeAllViewDisable()
        }
        else{
            sessionBtn.isHidden = true
            sessionImage.isHidden = true
            //addGesture()
            makeAllViewAble()
        }
    }
    
    func makeAllViewAble(){
        
        firstViewBadge.backgroundColor = UIColor(rgb: 0x395270)
        lastBadge.backgroundColor = UIColor(rgb: 0x395270)
        
        bestellungsBild.tintImageColor(color: UIColor(rgb: 0x395270))
        auftragBild.tintImageColor(color: UIColor(rgb: 0x395270))
        //inventurBild.tintImageColor(color: UIColor(rgb: 0x395270))
        picklisteBild.tintImageColor(color: UIColor(rgb: 0x395270))
        
        self.firstView.isUserInteractionEnabled = true
        //self.secondView.isUserInteractionEnabled = true
        self.thirdView.isUserInteractionEnabled = true
        self.LastView.isUserInteractionEnabled = true
    }
    func lagerChefView(darf : Bool){
        if darf{
              inventurBild.tintImageColor(color: UIColor(rgb: 0x395270))
             self.secondView.isUserInteractionEnabled = true
        }else{
                inventurBild.tintImageColor(color: UIColor.gray)
              self.secondView.isUserInteractionEnabled = false
        }
    }
    func makeAllViewDisable(){
        
        firstViewBadge.backgroundColor = UIColor.gray
        lastBadge.backgroundColor = UIColor.gray
        
        bestellungsBild.tintImageColor(color: UIColor.gray)
        auftragBild.tintImageColor(color: UIColor.gray)
        //inventurBild.tintImageColor(color: UIColor.gray)
        picklisteBild.tintImageColor(color: UIColor.gray)
        
        self.firstView.isUserInteractionEnabled = false
        //self.secondView.isUserInteractionEnabled = false
        self.thirdView.isUserInteractionEnabled = false
        self.LastView.isUserInteractionEnabled = false
    }
    

    
    func goToWareneingang(){
        let storyboard = UIStoryboard(name: "Wareneingang", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "WarenEingang") as! WEViewController

        if let navigationController = navigationController {
            if let obejcts = bestellungsAntwort?.objects{
                recentSearchesViewController.ListBestellung = obejcts
            }
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }
    
    func goToWarenausang(){
        let storyboard = UIStoryboard(name: "warenausgang", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "warenausgangCtrl") as! WarenausgangViewController
        if let navigationController = navigationController {
            if let obejcts = auftragsAntwort?.objects{
                recentSearchesViewController.ListBestellung = obejcts
            }
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }
    func goToLagerChef(){
        let storyboard = UIStoryboard(name: "Lager", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "LagerChefViewController") as! LagerChefViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }
    @objc func imageTappedFirst(){
        goToWareneingang()
        }

    @objc func imageTappedSecond(){
        goToLagerChef()
    }
    @objc func imageTappedThird(){
    }
    
    @objc func imageTappedLast(){
        goToWarenausang()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToInfo(){
        let storyboard = UIStoryboard(name: "info", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "infoViewController") as! infoViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }
    
    @objc func goInfo()
    {
        if Picklist.UserLagerChef.contains(Picklist.username!){
            goToInfo()
        }else{
            // create the alert
            let alert = UIAlertController(title: "Keine Berechtigung!!", message: "Not Allowed", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                //self.performSegue(withIdentifier: "done", sender: self)
            }))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func goChangedStatus()
    {
        
        let storyboard = UIStoryboard(name: "abmelden", bundle: nil)
        let recentSearchesViewController = storyboard.instantiateViewController(withIdentifier: "AbmeldenViewController") as! AbmeldenViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(recentSearchesViewController, animated: true)
        }
    }

    func initAllView(){
        let infoButton = UIImage(named: "icons8-info_filled")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: infoButton, style: .plain, target: self, action:  #selector(self.goInfo))
        //navigationController?.navigationBar.barTintColor = UIColor.lightGray
        
//        let logOutButton = UIImage(named: "icons8-change_filled")
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: logOutButton, style: .plain, target: self, action:  #selector(self.goChangedStatus))
        
        
        firstView.layer.cornerRadius = 10.0
        firstView.layer.shadowColor = UIColor.gray.cgColor
        firstView.layer.masksToBounds = false
        firstView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        firstView.layer.shadowOpacity = 1.0
        firstView.layer.shadowRadius = 5
        
        secondView.layer.cornerRadius = 10.0
        secondView.layer.shadowColor = UIColor.gray.cgColor
        secondView.layer.masksToBounds = false
        secondView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        secondView.layer.shadowOpacity = 1.0
        secondView.layer.shadowRadius = 5
        
        
        firstViewBadge.layer.cornerRadius = firstViewBadge.frame.width/2
        firstViewBadge.layer.masksToBounds = true
        
        lastBadge.layer.cornerRadius = firstViewBadge.frame.width/2
        lastBadge.layer.masksToBounds = true
        
        secondViewLabel.layer.cornerRadius = secondViewLabel.frame.width/2
        secondViewLabel.layer.masksToBounds = true
        
        secondViewLabel.isHidden = true
        
        thirdVuewLabel.layer.cornerRadius = thirdVuewLabel.frame.width/2
        thirdVuewLabel.layer.masksToBounds = true
        
        thirdVuewLabel.isHidden = true
        
        
        thirdView.layer.cornerRadius = 10.0
        thirdView.layer.shadowColor = UIColor.gray.cgColor
        thirdView.layer.masksToBounds = false
        thirdView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        thirdView.layer.shadowOpacity = 1.0
        thirdView.layer.shadowRadius = 5
        
        LastView.layer.cornerRadius = 10.0
        LastView.layer.shadowColor = UIColor.gray.cgColor
        LastView.layer.masksToBounds = false
        LastView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        LastView.layer.shadowOpacity = 1.0
        LastView.layer.shadowRadius = 5

    }
    
    func addGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedFirst))
        firstView.isUserInteractionEnabled = true
        firstView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerSecond = UITapGestureRecognizer(target: self, action: #selector(imageTappedSecond))
        secondView.isUserInteractionEnabled = true
        secondView.addGestureRecognizer(tapGestureRecognizerSecond)
        
        
        let tapGestureRecognizerThird = UITapGestureRecognizer(target: self, action: #selector(imageTappedThird))
        thirdView.isUserInteractionEnabled = true
        thirdView.addGestureRecognizer(tapGestureRecognizerThird)
        
        
        let tapGestureRecognizerLast = UITapGestureRecognizer(target: self, action: #selector(imageTappedLast))
        LastView.isUserInteractionEnabled = true
        LastView.addGestureRecognizer(tapGestureRecognizerLast)
        
    }
}

extension UIViewController{
    
    func userAlreadyExist(key : String) -> Bool {
        return UserDefaults.standard.object(forKey:key) != nil
    }
    
    func urlWithForBestellung(url: String, completion: @escaping (_ result: antwort) -> Void) {
        let jsonUrlString = url
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let data = data else {return}
            do{
                let webSiteDesc = try JSONDecoder().decode(antwort.self, from: data)
                completion(webSiteDesc)
            }catch let jsonErr{
                print(jsonErr)
            }
            
            }.resume()
        
    }
    
    func urlWithForAuftrag(url: String, completion: @escaping (_ result: antwort) -> Void) {
        
        let jsonUrlString = url
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let data = data else {return}
            do{
                let webSiteDesc = try JSONDecoder().decode(antwort.self, from: data)
                completion(webSiteDesc)
            }catch let jsonErr{
                print(jsonErr)
            }
            
            }.resume()
        
    }
    
}
extension UIImageView {
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
}
