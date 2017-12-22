//
//  LagerChefViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 20.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class LagerChefViewController: UIViewController {
    
    var komplett : antwort?
    var nichtkomplett : antwort?
    var objectTosend : [artikel] = []
    var selectedIndexFromDid = 0
    
    @IBOutlet weak var segement: UISegmentedControl!
    
    @IBOutlet weak var mytbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Lager Chef Ansicht (Puffer Lager)"
        
        alleNotComplete()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weiter"{
            let destinationVC = segue.destination as! LagerDetailViewController
            destinationVC.artikelReceeive = objectTosend
            
            guard let id  = nichtkomplett?.objects![selectedIndexFromDid]._id else {return}
            destinationVC.nummer = String(id)
        }
    }
    
    func urlWithForLager(url: String, completion: @escaping (_ result: antwort) -> Void) {
        let jsonUrlString = url
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let data = data else {return}
            do{
                let webSiteDesc = try JSONDecoder().decode(antwort.self, from: data)
                completion(webSiteDesc)
            }catch let jsonErr{
                print(jsonErr)
            }
        }.resume()
    }
    
    func alleComplete(){
        let longString = """
        http://139.59.129.92/api/dummyorder?q={"filters":[{"name":"comment","op":"eq","val":"komplett"}]}
        """
        let urlString = longString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        urlWithForLager(url: urlString!) {(result : antwort) in
            self.komplett = result
            DispatchQueue.main.async {
                self.mytbl.reloadData()
            }
        }
    }
    func alleNotComplete(){
        let longString = """
        http://139.59.129.92/api/dummyorder?q={"filters":[{"name":"comment","op":"eq","val":"nicht komplett"}]}
        """
        let urlString = longString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        urlWithForLager(url: urlString!) {(result : antwort) in
            self.nichtkomplett = result
            self.alleComplete()
        }
    }
    
    @IBAction func segmentCtrl(_ sender: Any) {
         mytbl.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension LagerChefViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         var returnValue = 0
        
        switch(segement.selectedSegmentIndex)
        {
        case 0:
             guard let count = nichtkomplett?.objects?.count else {return 0}
             returnValue = count
            break
        case 1:
            guard let count = komplett?.objects?.count else {return 0}
             returnValue = count
            break
            
        default:
            break
            
        }
        return returnValue
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch(segement.selectedSegmentIndex)
        {
        case 0:
            if let nummer = nichtkomplett?.objects?[indexPath.row].bestellungsNr{
                               cell.textLabel?.text  = String(describing:nummer)
                        }
            if let detail = nichtkomplett?.objects?[indexPath.row].comment{
                cell.detailTextLabel?.text = detail
            }
              cell.isUserInteractionEnabled = true
            break
        case 1:
            if let nummer = komplett?.objects?[indexPath.row].bestellungsNr{
                cell.textLabel?.text  = String(describing:nummer)
            }
            if let detail = komplett?.objects?[indexPath.row].comment{
                cell.detailTextLabel?.text = detail
            }
            cell.isUserInteractionEnabled = false
            break
            
        default:
            break
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexFromDid = indexPath.row
        switch(segement.selectedSegmentIndex)
        {
        case 0:
            guard let object  = nichtkomplett?.objects![indexPath.row].artikel else {return }
            objectTosend = object
            break
        case 1:
            guard let object  = komplett?.objects![indexPath.row].artikel else {return }
            objectTosend = object
            break
        default:
            break
            
        }
        self.performSegue(withIdentifier: "weiter", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch(segement.selectedSegmentIndex)
        {
        case 0:
            guard let count  = nichtkomplett?.objects?.count else {return title}
            title = "nicht komplett (\(String(describing: count)))"
            break
        case 1:
            guard let count  = komplett?.objects?.count else {return title}
            title = "komplett heute : (\(String(describing: count)))"
            break
        default:
            break
            
        }
        return title
    }
}
