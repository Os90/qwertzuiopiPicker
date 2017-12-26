//
//  ViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 05.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit
import BarcodeScanner
import ActionSheetPicker_3_0
import MIBadgeButton_Swift
import OrderedDictionary

class ViewController: UIViewController {
    
    fileprivate var mapViewController: BarcodeScannerController?

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var kartonNummer: UILabel!
    
    var eanCode = String()

     var MyindexPath = 0
    
    let list_2 =  [String: Int]()
    
    @IBOutlet weak var kartonNr: UILabel!
    var count = 1
    
    var atIntex = 0
    var kartons =  ["2", "1", "5","2", "6", "7","1", "13", "15"]
    var anzahls =  ["10", "20", "30","40","50","60"]
    var kartonChose = String()
    var anzahlChose = String()

//    var selectedIndexPath: NSIndexPath{
//        didSet{
//            myCollectionView.reloadData()
//        }
//    }

    @IBOutlet weak var NextButton: MIBadgeButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mapController = childViewControllers.last as? BarcodeScannerController else {
            fatalError("Check storyboard for missing MapViewController")
            
  
        }
        
        mapController.codeDelegate = self
        mapController.errorDelegate = self
        mapController.dismissalDelegate = self
        mapViewController = mapController

        myCollectionView.delegate = self
        myCollectionView.dataSource = self

    }
    
    @IBAction func EingabeButton(_ sender: Any) {
        
        ActionSheetMultipleStringPicker.show(withTitle: "Multiple String Picker", rows: [
            kartons,
            anzahls
            ], initialSelection: [2, 2], doneBlock: {
                picker, indexes, values in
                self.showLabel(indexes!)
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    func showLabel(_ index : [Any]){
        kartonChose = kartons[kartons.index(before: index[0] as! Int) + 1]
        anzahlChose = anzahls[anzahls.index(before: index[1] as! Int) + 1]
        myCollectionView.reloadData()
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destination
        
        if let mapController = destination as? BarcodeScannerController {
            mapViewController = mapController
        }
    }
    @IBAction func mach(_ sender: Any) {

        if eanCode.isEmpty || kartonChose.isEmpty {
            // create the alert
            let alert = UIAlertController(title: "Unvollständige Eingabe", message:"Bitte überprüfen", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else{
            myCollectionView.setNeedsLayout()
            myCollectionView.layoutIfNeeded()
            
            MyindexPath = MyindexPath + 1
            
            count = count + 1
            
            myCollectionView.reloadData()
            
            let indexPath = IndexPath(row: MyindexPath, section: 0)
            
            atIntex = indexPath.row
            
            myCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
            eanCode.removeAll()
            anzahlChose.removeAll()
            kartonChose.removeAll()
            
            
            NextButton.badgeString = String(MyindexPath)
            
            
            
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
}


extension ViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        eanCode = code
        myCollectionView.reloadData()
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.mapViewController?.resetWithError()
        }
    }
}

extension ViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension ViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        if indexPath.row == atIntex {
            
            cell.backgroundColor = UIColor.black
            
        }
        else{
              cell.backgroundColor = UIColor.green
        }
        cell.firstLabel.text = eanCode
        cell.menge.text = anzahlChose
        cell.kartonNrCell.text = kartonChose
        
       // cell.layer.borderColor = UIColor.red.cgColor
        
        cell.myView.layer.borderColor = UIColor.red.cgColor
        cell.myView.backgroundColor = UIColor.clear

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedIndexPath = indexPath as NSIndexPath
        kartonNr.text = "Karont \(indexPath.row)"
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 4, 10, 4)
    }
 
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = myCollectionView.contentOffset;
        let width  = self.myCollectionView.bounds.size.width;
        
        let index     = round(offset.x / width);
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
    
}
