//
//  CompleteWAViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 07.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class CompleteWAViewController: UIViewController {
    
    @IBOutlet weak var erfolgreichView: UIView!
    @IBOutlet weak var nichterfolgreichView: UIView!
    @IBOutlet weak var halleView: UIView!
    
    
    @IBOutlet weak var okbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setTitle(title: "Auftrags Nummer", subtitle: "\(1235)")
        erfolgreichView.getCorner(erfolgreichView)
        nichterfolgreichView.getCorner(nichterfolgreichView)
        halleView.getCorner(halleView)        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func okBtnAction(_ sender: Any) {
        Picklist.durchlaufAuftrage = Picklist.durchlaufAuftrage + 1
        navigationController?.popToRootViewController(animated: true)
    }
}

extension UIView{
    
    func getCorner(_ myview : UIView){
        myview.layer.cornerRadius = 10.0
        myview.layer.shadowColor = UIColor.gray.cgColor
        myview.layer.masksToBounds = false
        myview.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        myview.layer.shadowOpacity = 1.0
        myview.layer.shadowRadius = 5
    }
}
