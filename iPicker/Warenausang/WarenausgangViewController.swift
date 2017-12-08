//
//  WarenausgangViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class WarenausgangViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.async {
//            let closeButtonImage = UIImage(named: "icons8-left_4")
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(self.goBack))
//
//        }

    }
    
    @objc func goBack()
    {
        if let navigationController = navigationController {
            //NotificationCenter.default.post(name:Notification.Name(GSNotifications.backToStart), object: nil, userInfo: nil)
            navigationController.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ordernummerSelect(_ nummer : Int){
        
        self.performSegue(withIdentifier: "ordernummer", sender: self)
    }
    
}
extension WarenausgangViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Order numer : q2343124"
        cell.detailTextLabel?.text = "Seit 15 min"
        //cell.imageView?.image = UIImage(named :"icons8-checkmark_filled-1")
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 97.00
//
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Aufträge (0)"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.ordernummerSelect(indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
//
//        let favorite = UITableViewRowAction(style: .normal, title: "OK") { action, index in
//            print("ok button tapped")
//
//        }
//        favorite.backgroundColor = .red
//
//        return [favorite]
//    }
}
