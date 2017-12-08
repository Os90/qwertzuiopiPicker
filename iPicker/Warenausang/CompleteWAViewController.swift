//
//  CompleteWAViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 07.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class CompleteWAViewController: UIViewController {
    @IBOutlet weak var okbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setTitle(title: "Auftrags Nummer", subtitle: "\(1235)")
        okbtn.layer.cornerRadius = 10.0
        okbtn.layer.masksToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func okBtnAction(_ sender: Any) {
        Picklist.durchlaufAuftrage = Picklist.durchlaufAuftrage + 1
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}
