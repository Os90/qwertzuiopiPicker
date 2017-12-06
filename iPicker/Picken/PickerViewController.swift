//
//  PickerViewController.swift
//  iPicker
//
//  Created by Osman A on 17.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit
import BarcodeScanner

class PickerViewController: UIViewController {
    
    fileprivate var mapViewController: BarcodeScannerController?
    
    var wagenid = Int()
    var pickid = Int()
    @IBOutlet weak var mytbl: UITableView!
    
    @IBOutlet weak var doneView: UIView!
    
    @IBOutlet weak var totalCount: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var myTuple: (key: Int, val: String)? = nil
    
    var myCount = 0
    var position = 0
    
    var positionText  = String()
    var EanText  = String()
    
    var beimStoppen = String()
    var timer = Timer()
    var startTime = TimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        mytbl.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "Cell")
        guard let mapController = childViewControllers.last as? BarcodeScannerController else {
            fatalError("Check storyboard for missing MapViewController")
        }
        
        mapController.codeDelegate = self
        mapController.errorDelegate = self
        mapController.dismissalDelegate = self
        mapViewController = mapController
        
        
//        let logo = UIImage(named: "icons8-barcode_scanner_2_filled")
//        let imageView = UIImageView(image:logo)
//        imageView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = imageView
        
        let aSelector : Selector = #selector(PickerViewController.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        self.navigationItem.title = "WagenID:\(wagenid)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        timeLabel.text = "\(strMinutes):\(strSeconds)"
       // beimStoppen = timeLabel.text!
    }

    
    func IncrementMyCount(){
        
        if myCount < 8{
            position = 0
            myCount = myCount + 1
            EanText = ""
            positionText  = ""
            mytbl.reloadData()
            scrollToSelectedRow()
        }
        else{
            let refreshAlert = UIAlertController(title: "FERTIG", message: "Alle Artikeln wurden erfolgreich abgescannt, drücke auf OK um es abzuschließen", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
               self.performSegue(withIdentifier: "ok", sender: self)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }

    }
    
    func checkPosition(_ pos : String){
        
        positionText = pos
        
        position = position + 1
        
        mytbl.reloadData()
    }
    
    func checkEan(_ ean : String){
        
        EanText  = ean
        IncrementMyCount()
    }

    @IBAction func myButton(_ sender: Any) {
        IncrementMyCount()
    }
    
    func scrollToSelectedRow() {
        let indexPath = IndexPath(row: myCount, section: 0)
        let selectedRows = indexPath
        mytbl.scrollToRow(at: selectedRows, at: .bottom, animated: true)
    }
}

extension PickerViewController: UITableViewDelegate,UITableViewDataSource{
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PickerTableViewCell
        
        if indexPath.row == myCount {
            cell.changeColorToblack()
            cell.PositionLabel.text  = "Position:\(positionText)"
            cell.EanLabel.isHidden = false
            cell.EanLabel.text  = "EAN :\(EanText)"
            cell.CountLabel.text = "\(4) mal "
            
            if position == 0{
                cell.PositionLabel.textColor = UIColor.red
            }
            else{
                cell.EanLabel.textColor = UIColor.red
            }
        }
        else{
            cell.changeColorToGray()
            cell.PositionLabel.text  = "F12-12-34-23"
            cell.EanLabel.isHidden = true
        }
        
        if indexPath.row < myCount{
             cell.StatusImg.isHidden = false
            cell.StatusImg.image = UIImage(named: "icons8-checkmark_filled")
        }
        else{
            cell.StatusImg.isHidden = true
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == myCount{
            return 120.0
        }
        return 50.0
    }
}
extension PickerViewController: BarcodeScannerCodeDelegate {

    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        
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

extension PickerViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension PickerViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
