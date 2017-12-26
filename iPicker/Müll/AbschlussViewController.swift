//
//  AbschlussViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 09.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class AbschlussViewController: UIViewController {

    @IBOutlet weak var mytbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func speichern(_ sender: Any) {
       self.navigationController!.popToRootViewController(animated: true)
    }
}

extension AbschlussViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.textLabel?.text  = "adfadsf"
        return cell
    }
    
}
