//
//  CompleteWEViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 08.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class CompleteWEViewController: UIViewController {
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var doneImage: UIImageView!
    @IBOutlet weak var erfolgreich: UILabel!
    @IBOutlet weak var nichtErfolgreich: UILabel!
    
    @IBOutlet weak var OkBtn: UIButton!
    
    @IBOutlet weak var abbrechenBtn: UIButton!
    
    var richtig = 0
    var falsch = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OkBtn.layer.cornerRadius = 10.0
        OkBtn.layer.masksToBounds = true
        self.navigationItem.setTitle(title: "Bestellungsnummer", subtitle: "\(bestellugAntwort.bestellungsNr)")
        self.navigationItem.setHidesBackButton(true, animated: false)
        initComplete()
        
        UIView.animate(withDuration: 1.5, animations: {
            self.doneImage.alpha = 1.0
        })
    }

    func initComplete(){
        
        titlelabel.text = "Ingesamt Ware \(bestellugAntwort.bestellugArtikel.count)"
        
        time.text  = "Dauer : \(bestellugAntwort.bestellugStart_time)"
        
        filter()
        }
    
    func filter(){
        
        for i in 0 ... bestellugAntwort.bestellugArtikel.count - 1 {
            
            if bestellugAntwort.bestellugArtikel[i].belegt == 0{
                falsch = falsch + 1
            }
            else{
                richtig = richtig + 1
            }
            
        }
         erfolgreich.text = String(richtig)
        nichtErfolgreich.text = String(falsch)
        
    }
    func sessionInitAll(){
        let prefs = UserDefaults.standard
        //keyValue = prefs.string(forKey:"TESTKEY")
        prefs.removeObject(forKey:"session")
        prefs.removeObject(forKey:"was")
        prefs.removeObject(forKey:"struct")
        let empty : objects? = nil
        Picklist.sessionObject = empty
    }
    
    func saveResultToServer() -> Bool{
        return true
    }

    @IBAction func bestätigen(_ sender: Any) {
        if let navigationController = navigationController {
            if saveResultToServer(){
                sessionInitAll()
                Picklist.durchlaufBestellungen = Picklist.durchlaufBestellungen + 1
                navigationController.popToRootViewController(animated: true)
            }else{
                print("Kein Internet")
            }
        }
        
    }
    @IBAction func abbrechenAction(_ sender: Any) {
        
        //alert
        //if ja
        let Snummer = Picklist.sessionObject?.bestellungsNr
        let Susername = Picklist.username
        
        cancelSession(wer: Susername, nummer: Snummer!)
        
    }
    
    func cancelSession(wer : String, nummer: Int){
        
    }
    
    @IBOutlet weak var abbrechenAction: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
