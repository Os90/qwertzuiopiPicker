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
        test4(completion: { isSuccess in
            if isSuccess{
                print("isSuccess")
            }
        })
//
//        test2(completion: { isSuccess in
//            if isSuccess{
//                print("isSuccess")
//            }
//        })
        
//        test3(completion: { isSuccess in
//            if isSuccess{
//                print("isSuccess")
//            }
//        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func test3(completion: @escaping (_ wert : Bool) -> Void) {
        
        let longString = """
http://139.59.129.92/api/dummyorder?q={"filters":[{"name":"status","op":"eq","val":"WE"}]}
"""
//     //  http://139.59.129.92/api/dummyorder?q={"filters":[{"name":"status","op":"eq","val":"WE"}]}
//        let baseUrl = "http://139.59.129.92/api/dummyorder?q={"
//
//        var searchURL = baseUrl + "/" + "filters" + "/" + ":[{" + "/" + "name" + "/" + ":" + "/" + "status" + "/" + "," + "/"
//            + "op" + "/" + ":" + "/" + "eq" + "/" + "," + "/" + "val" + "/" + ":" + "/" + "WE" + "/" + "}]}"
//
//        searchURL.enco
        
        let request = NSMutableURLRequest(url: NSURL(string: longString)! as URL)
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
    
    func testObject(){
        var testantwort  =  antwort()
        var testobjects = objects()
        var testartikel = artikel()
        testartikel.comment = "nicht ok"
        testartikel.ean = 2341324
        testartikel.belegt = 0
        testartikel.pickerID = 101
        testartikel.menge = 100
        testartikel.position = "A8-008-008"
        
        var testartikel1 = artikel()
        testartikel1.comment = "nicht ok"
        testartikel1.ean = 1111111
        testartikel1.belegt = 0
        testartikel1.pickerID = 33
        testartikel1.menge = 1
        testartikel1.position = "A1-118-118"
        
        var testartikelArray : [artikel] = []
        testartikelArray.append(testartikel)
        testartikelArray.append(testartikel1)
        
        testobjects.artikel = testartikelArray
        testobjects.bestellungsNr = 20
        testobjects._id = 2
        testobjects.complete = false
        testobjects.status = "WE"
        var testObjectsArray : [objects] = []
        
        testObjectsArray.append(testobjects)
        
        testantwort.objects = testObjectsArray
    }
    
    
//    func PostResultSession(urlString: antwort, completion: @escaping (_ wert : Bool) -> Void) {
//
//       // guard let id = Picklist.sessionObject?._id else {return}
//        let myURL = "http://139.59.129.92/api/dummyorder/\(id)"
//        let request = NSMutableURLRequest(url: NSURL(string: myURL)! as URL)
//        request.httpMethod = "PATCH"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let encoder = JSONEncoder()
//        do{
//            let jsonData = try encoder.encode(Picklist.sessionObject)
//            request.httpBody = jsonData
//            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
//        } catch {
//            print("ERROR")
//        }
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//
//            if error != nil {
//                print("error=\(String(describing: error))")
//                completion(false)
//                return
//            }
//
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("responseString = \(String(describing: responseString))")
//            completion(true)
//            return
//        }
//        task.resume()
//    }
    
   func test(completion: @escaping (_ wert : Bool) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/dummyorder/5")! as URL)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do{
            let json: [String: Any] = ["status": "WA"]
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
    func test4(completion: @escaping (_ wert : Bool) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://139.59.129.92/api/dummyorder/2")! as URL)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do{
            let json: [String: Any] = ["status": "WE"]
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
