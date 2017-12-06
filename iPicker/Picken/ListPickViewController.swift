//
//  ListPickViewController.swift
//  iPicker
//
//  Created by Osman A on 24.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

struct pickerListStruct : Decodable{
    
    var idPick = Int()
    var totalCount = Int()

    static var myPickerArray: [pickerListStruct] = []
}


class ListPickViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var totalCountPickIDs: UILabel!
    
    @IBOutlet weak var mytbl: UITableView!
    
    var fromServerPickerList : [pickerListStruct] = []
    
    var selectPickID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         mytbl.register(UINib(nibName: "ListPickCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        let a = pickerListStruct.init(idPick: 2348293, totalCount: 34)
        let b = pickerListStruct.init(idPick: 1234123, totalCount: 11)
        let c = pickerListStruct.init(idPick: 234134, totalCount: 24)
        
          pickerListStruct.myPickerArray.append(a)
          pickerListStruct.myPickerArray.append(b)
          pickerListStruct.myPickerArray.append(c)
        
        username.text = "Hallo, Osman"
        totalCountPickIDs.text =  String(pickerListStruct.myPickerArray.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! WagenViewController
        destinationVC.PickID = selectPickID
    }
}

extension ListPickViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  pickerListStruct.myPickerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListPickerCell
        cell.PickID.text =  String(pickerListStruct.myPickerArray[indexPath.row].idPick)
        cell.totalCount.text = String(pickerListStruct.myPickerArray[indexPath.row].totalCount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 76.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = pickerListStruct.myPickerArray[indexPath.row].idPick
        selectPickID = id
        performSegue(withIdentifier: "weiter", sender: self)
    }

}
