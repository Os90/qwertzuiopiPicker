//
//  LagerChefViewController.swift
//  iPicker
//
//  Created by Osman Ashraf on 20.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class LagerChefViewController: UIViewController {
    
    var komplett : String?
    var nichtkomplett : String?
    
    
    @IBOutlet weak var segement: UISegmentedControl!
    
    @IBOutlet weak var mytbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alle()
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
    
    func alle(){
        let longString = """
        http://139.59.129.92/api/dummyorder?q={"filters":[{"name":"status","op":"eq","val":"WE"}]}
        """
        let urlString = longString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        urlWithForLager(url: urlString!) {(result : antwort) in
            print(result)
        }
    }
    
    @IBAction func segmentCtrl(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension LagerChefViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
}
