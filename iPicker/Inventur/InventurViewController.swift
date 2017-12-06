//
//  InventurViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 19.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit
import BarcodeScanner

class InventurViewController: UIViewController {
    
    fileprivate var mapViewController: BarcodeScannerController?
    
    var beimStoppen = String()
    var timer = Timer()
    var startTime = TimeInterval()
    
    var positionText  = String()
    var EanText  = String()
    
    @IBOutlet weak var mytlb: UITableView!
    var myCount = 0
    var position = 0
    var mengeändern = false
    var mengeändernAtIndex = 0
    var defaultMenge = "01"
    
    var myarray : [Picklist] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        mytlb.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "Cell")
        guard let mapController = childViewControllers.last as? BarcodeScannerController else {
            fatalError("Check storyboard for missing MapViewController")
        }
        
        mapController.codeDelegate = self
        mapController.errorDelegate = self
        mapController.dismissalDelegate = self
        mapViewController = mapController
        
        
       
        let aSelector : Selector = #selector(InventurViewController.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        
        //myarray.append(1)
        
        self.navigationItem.title = "00:00"
    }
    
    @IBAction func speichern(_ sender: Any) {
       performSegue(withIdentifier: "fertig", sender: self)
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
        self.navigationItem.title = "\(strMinutes):\(strSeconds)"
        // beimStoppen = timeLabel.text!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkPosition(_ pos : String){
        
        positionText = pos
        
        position = position + 1
        
        mytlb.reloadData()
    }
    
    func checkEan(_ ean : String){
        
        EanText  = ean
        IncrementMyCount()
    }
    
    func IncrementMyCount(){
        
        let a = Picklist.init(id: myCount, ean: EanText, position: positionText, time: "00", menge: Int(defaultMenge)!)
        
        
        //Picklist.meineListe.ean
        
        Picklist.myArray.append(a)
        
        myarray = Picklist.myArray
        
                    position = 0
                    //myarray.append(1)
                    myCount = myCount + 1
                    EanText = ""
                    positionText  = ""
                    defaultMenge = "01"
                    mytlb.reloadData()
                    scrollToSelectedRow()
    }
    func scrollToSelectedRow() {
        let indexPath = IndexPath(row: myCount, section: 0)
        let selectedRows = indexPath
        mytlb.scrollToRow(at: selectedRows, at: .bottom, animated: true)
    }
    func addButon(){
        let btnleft : UIButton = UIButton(frame: CGRect(x:0, y:0, width:35, height:35))
        btnleft.setTitleColor(UIColor.white, for: .normal)
        btnleft.contentMode = .right
        
        btnleft.setImage(UIImage(named :"icons8-edit_filled"), for: .normal)
        btnleft.addTarget(self, action: #selector(InventurViewController.myAction), for: .touchDown)
        let backBarButon: UIBarButtonItem = UIBarButtonItem(customView: btnleft)
        //self.navigationItem.setLeftBarButtonItems([backBarButon], animated: false)
        self.navigationItem.setRightBarButtonItems([backBarButon], animated: false)
    }
    
    @objc func myAction() {
        
        self.mengeändern = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let indexPath = IndexPath(row: myCount, section: 0)
        let selectedRows = indexPath
        mytlb.scrollToRow(at: selectedRows, at: .bottom, animated: true)
        mytlb.reloadData()
    }
}

extension InventurViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myarray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PickerTableViewCell
        
        if indexPath.row == myCount {
            cell.changeColorToblack()
            cell.PositionLabel.text  = "Position:\(positionText)"
            cell.EanLabel.isHidden = false
            cell.EanLabel.text  = "EAN :\(EanText)"
            cell.CountLabel.text = "\(defaultMenge) mal "
            
            if position == 0{
                cell.PositionLabel.textColor = UIColor.red
            }
            else{
                cell.EanLabel.textColor = UIColor.red
            }
        }
        else{
            cell.changeColorToGray()
            cell.PositionLabel.text  = myarray[indexPath.row].position
            cell.CountLabel.text = String(myarray[indexPath.row].menge)
            cell.EanLabel.text =  myarray[indexPath.row].ean
        }
        
        if indexPath.row < myCount{
            cell.StatusImg.isHidden = false
            cell.StatusImg.image = UIImage(named: "icons8-checkmark_filled")
        }
        else{
            cell.StatusImg.isHidden = true
        }
        cell.layer.borderWidth = 0.0
        cell.editImage.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if mengeändern && mengeändernAtIndex == indexPath.row{
            return 134.0
        }
        else{
            let section = indexPath.section
            let row = indexPath.row
            if section == 0 && row == myCount{
                return 134.0
            }
            else{
                return 50.0
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.contentView.backgroundColor = UIColor.orange
//        cell?.backgroundColor = UIColor.orange
//    }
//
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.contentView.backgroundColor = UIColor.black
//        cell?.backgroundColor = UIColor.black
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == myCount{

            //1. Create the alert controller.
            let alert = UIAlertController(title: "Menge Eingabe", message: "nur Decimal Zahlen", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.keyboardType = .decimalPad
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                {
                    print("Text field: \(String(describing: textField.text))")
                    self.defaultMenge = textField.text!
                    self.mytlb.reloadData()
                }
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        else{
            mengeändern = true
            mengeändernAtIndex = indexPath.row
            addButon()
            mytlb.reloadData()
            let alert = UIAlertController(title: "Menge Ändern", message: "nur Decimal Zahlen", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.keyboardType = .decimalPad
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Ja, bitte ändern", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                {
                    print("Text field: \(String(describing: textField.text))")
                    Picklist.myArray[indexPath.row].menge = Int(textField.text!)!
                    self.myarray.removeAll()
                    self.myarray = Picklist.myArray
                    //self.defaultMenge = textField.text!
                    self.mytlb.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "Nein", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                {
//                    print("Text field: \(String(describing: textField.text))")
//                    Picklist.myArray[indexPath.row].menge = Int(textField.text!)!
//                    self.myarray.removeAll()
//                    self.myarray = Picklist.myArray
//                    //self.defaultMenge = textField.text!
//                    self.mytlb.reloadData()
                }
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        let cell = mytlb.cellForRow(at: indexPath) as! PickerTableViewCell
        
        if mengeändern{
            cell.editImage.isHidden = false
        }
        else{
            cell.editImage.isHidden = true
        }
        
    }

}

extension InventurViewController: BarcodeScannerCodeDelegate {
    
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        
        if self.mengeändern{
            
            let alert = UIAlertController(title: "Editier Modus auschalten", message: "OK", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.mapViewController?.resetWithError()
                alert.dismiss(animated: true, completion: nil)
            }
        }
        else{
            //
            switch position {
            case 0:
                checkPosition(code)
                break
            case 1:
                checkEan(code)
                break
            default:
                print("ERROR")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.mapViewController?.resetWithError()
            }
        }

    }
}

extension InventurViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension InventurViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

