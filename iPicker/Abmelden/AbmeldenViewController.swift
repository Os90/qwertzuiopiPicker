//
//  AbmeldenViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 06.01.18.
//  Copyright © 2018 Osman Ashraf. All rights reserved.
//

import UIKit

class AbmeldenViewController: UIViewController {
    @IBOutlet weak var breakView: UIView!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var work: UIView!
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.navigationItem.title  = "Status wechseln"
        self.indicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         rechtsOben()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //status absenden
    }
    
    func saveToUserdefaults(_ status : String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(status, forKey: "status")
 
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: logOutButton, style: .plain, target: self, action:nil)
        
       
    }
    
    func statusUpdaten(){
        
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    @objc func handleTapGesture(sender : UITapGestureRecognizer)
    {
        let v = sender.view!
        
        let alertController = UIAlertController(
            title: "Status",
            message: "Durch Ja werden Sie den Status wechseln!",
            preferredStyle : .alert)
        
        let image = UIImage(named : v.accessibilityHint!)
        
        alertController.addImage(image: image!)
        
        alertController.addAction(UIAlertAction(title:"Ja", style: .default, handler : {(alert:UIAlertAction) in
          
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(v.tag, forKey: "status")
            self.rechtsOben()
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.statusUpdaten()
        }))
        alertController.addAction(UIAlertAction(title:"Nein", style: .default, handler : nil))
        
        self.present(alertController,animated: true,completion: nil)
        
        
    }

    func initView(){
    breakView.layer.cornerRadius = 10.0
    breakView.layer.shadowColor = UIColor.gray.cgColor
    breakView.layer.masksToBounds = false
    breakView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
    breakView.layer.shadowOpacity = 1.0
    breakView.layer.shadowRadius = 5
    breakView.tag = 1
    breakView.accessibilityHint = "icons8-porridge_filled-1"
    
    sleepView.layer.cornerRadius = 10.0
    sleepView.layer.shadowColor = UIColor.gray.cgColor
    sleepView.layer.masksToBounds = false
    sleepView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
    sleepView.layer.shadowOpacity = 1.0
    sleepView.layer.shadowRadius = 5
        sleepView.tag = 2
         sleepView.accessibilityHint = "icons8-sleep_filled-1"
    
    
    logoutView.layer.cornerRadius = 10.0
    logoutView.layer.shadowColor = UIColor.gray.cgColor
    logoutView.layer.masksToBounds = false
    logoutView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
    logoutView.layer.shadowOpacity = 1.0
    logoutView.layer.shadowRadius = 5
    logoutView.tag = 3
    logoutView.accessibilityHint = "icons8-logout_rounded_up_filled-1"
        
    work.layer.cornerRadius = 10.0
    work.layer.shadowColor = UIColor.gray.cgColor
    work.layer.masksToBounds = false
    work.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
    work.layer.shadowOpacity = 1.0
    work.layer.shadowRadius = 5
    work.tag = 4
    work.accessibilityHint = "icons8-worker_filled-1"
        
    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(sender:)))
        sleepView.isUserInteractionEnabled = true
        sleepView.addGestureRecognizer(tapGestureRecognizer1)

    let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(sender:)))
        work.isUserInteractionEnabled = true
        work.addGestureRecognizer(tapGestureRecognizer2)
        
    let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(sender:)))
        logoutView.isUserInteractionEnabled = true
        logoutView.addGestureRecognizer(tapGestureRecognizer3)
        
    let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(sender:)))
        breakView.isUserInteractionEnabled = true
        breakView.addGestureRecognizer(tapGestureRecognizer4)
    }
}
