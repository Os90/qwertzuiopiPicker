//
//  TestViewController.swift
//  iPicker
//
//  Created by Osman A on 16.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        test(completion: { isSuccess in
            if isSuccess{
                print("isSuccess")
            }
        })
        
        test2(completion: { isSuccess in
            if isSuccess{
                print("isSuccess")
            }
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   func test(completion: @escaping (_ wert : Bool) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/dummyorder/1")! as URL)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do{
            let json: [String: Any] = ["status": "OSMAAAAAN"]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                completion(false)
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            completion(true)
            return
        }
        task.resume()
    }
    
    func test2(completion: @escaping (_ wert : Bool) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/canceled")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do{
            let json: [String: Any] = ["mission_order_id": "OSMAN", "user": "TESTOSMAN",]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                completion(false)
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            completion(true)
            return
        }
        task.resume()
    }
    
}
