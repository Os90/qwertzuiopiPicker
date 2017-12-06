//
//  WagenViewController.swift
//  iPicker
//
//  Created by Osman A on 17.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit
import BarcodeScanner

class WagenViewController: UIViewController {
    
    var PickID = Int()
    
    var WagenID = Int()
    
    fileprivate var mapViewController: BarcodeScannerController?

    @IBOutlet weak var weiterBTn: UIButton!
    @IBOutlet weak var DoneView: UIImageView!
    
    @IBOutlet weak var wagenText: UILabel!
    
    @IBOutlet weak var wagenEingabe: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        weiterBTn.isHidden = true
        DoneView.isHidden = true
        
        
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
        
        wagenEingabe.isHidden = true
        
        wagenEingabe.delegate = self
        self.title = "PickID : \(PickID)"
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.title = "\(WagenID)"
//    }
////    override func viewWillAppear(_ animated: Bool) {
////        self.title = "PickID : \(PickID)"
////    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Weiter(_ sender: Any) {
        
        if let vc = self.childViewControllers.last{
            vc.removeFromParentViewController()
        }
        
        WagenID = Int(wagenText.text!)!
    
        performSegue(withIdentifier: "weiter", sender: self)

    }
    
    @IBAction func tastaturEingabeBtn(_ sender: Any) {
        
        wagenEingabe.isHidden = false
        
        wagenEingabe.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? PickerViewController{
            detailVC.wagenid = Int(wagenText.text!)!
            detailVC.pickid = PickID
        }
    }
    
    func WagenCodeCheck(_ code : String){
        if code != ""{
            self.DoneView.isHidden = false
            self.weiterBTn.isHidden = false
            wagenText.text = code
        }
    }
}
extension WagenViewController: BarcodeScannerCodeDelegate {
    
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {

        WagenCodeCheck(code)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.mapViewController?.resetWithError()
        }
    }
}

extension WagenViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension WagenViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension WagenViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wagenEingabe.resignFirstResponder()
        WagenCodeCheck(textField.text!)
        
        return false
    }
}
