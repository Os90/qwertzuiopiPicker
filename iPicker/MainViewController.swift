//
//  MainViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 07.11.2017.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var LastView: UIView!
    
    @IBOutlet var secondViewLabel: UIView!
    
    @IBOutlet var thirdVuewLabel: UIView!
    
    var eingeloggt = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAllView()
    }
    func userAlreadyExist() -> Bool {
        return UserDefaults.standard.object(forKey: "name") != nil
    }
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            if self.userAlreadyExist() == false {
                self.performSegue(withIdentifier: "login", sender: self)
            }
            else{
                self.eingeloggt = true
                
                self.loginLabel.text = "Eingeloggt"
                
//                self.fetchDataFromServer()
//                self.countPick.text = String(self.pickIDStationID.count)
//                let defaults = UserDefaults.standard
//                self.Username.text = defaults.object(forKey:"name") as! String?
            }
        }
        
        //        let od = OrderedDictionary()
        //        od["Tim"] = 24
        //        print(od.description)
    }
    

    
    @objc func imageTappedFirst(){
//        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Wareneingang", bundle: nil)
//        let nav = mainStoryboardIpad.instantiateViewController(withIdentifier: "WarenEingang") as! UINavigationController
//        self.navigationController!.pushViewController(nav, animated: true)
        
        //self.window?.rootViewController = nav
        
        let loginVC = UIStoryboard(name: "Wareneingang", bundle: nil).instantiateViewController(withIdentifier: "WarenEingang") as! UINavigationController
        //dself.navigationController?.pushViewController(loginVC, animated: true)
        
        self.present(loginVC, animated: true, completion: nil)
        
        //present( UIStoryboard(name: "Wareneingang", bundle: nil).instantiateViewController(withIdentifier: "WE") as UIViewController, animated: true, completion: nil)
//
//        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "WarenEingang")
//        self.navigationController!.pushViewController(VC1, animated: true)
//
//        let storyboard = UIStoryboard(name: "Wareneingang", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "WarenEingang") as! WEViewController
//        present(vc, animated: true, completion: nil)
        
        
        //performSegue(withIdentifier: "Picken", sender: self)
        
//
//        let storyboard: UIStoryboard = UIStoryboard(name: "Wareneingang", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "WarenEingang")
//        self.show(vc, sender: self)
        }
    
    
    @objc func imageTappedSecond(){
        performSegue(withIdentifier: "Inventur", sender: self)
    }
    @objc func imageTappedThird(){
        performSegue(withIdentifier: "picken", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initAllView(){
        
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
        
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedFirst))
        firstView.isUserInteractionEnabled = true
        firstView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerSecond = UITapGestureRecognizer(target: self, action: #selector(imageTappedSecond))
        secondView.isUserInteractionEnabled = true
        secondView.addGestureRecognizer(tapGestureRecognizerSecond)
        
        
        let tapGestureRecognizerThird = UITapGestureRecognizer(target: self, action: #selector(imageTappedThird))
        thirdView.isUserInteractionEnabled = true
        thirdView.addGestureRecognizer(tapGestureRecognizerThird)
    }
}

extension UIViewController{
    func urlWithForBestellung(url : String){
        
        let jsonUrlString = url
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let data = data else {return}
            do{
                let webSiteDesc = try JSONDecoder().decode(bestellung.self, from: data)
                Picklist.WarenEingang.append(webSiteDesc)
//                print(Picklist.WarenEingang.count)
//                print(Picklist.WarenEingang[0].liste.count)
//                print(Picklist.WarenEingang[0].liste)
            }catch let jsonErr{
                print(jsonErr)
                }
            
            }.resume()
    }

}