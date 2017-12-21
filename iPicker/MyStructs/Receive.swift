//
//  Receive.swift
//  iPicker
//
//  Created by Osman Ashraf on 02.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import Foundation

struct antwort : Decodable{
    var num_results:Int?
    var page: Int?
    var total_pages: Int?
    var objects : [objects]?
}

struct antwortNotComplete : Decodable{
    var num_results:Int?
    var page: Int?
    var total_pages: Int?
    var objects : [objects]?
}


struct objects : Decodable,Encodable{
    var _created: Int?
    var _id : Int?
    var _update : Int?
    var status : String?
    var bestellungsNr: Int?
    var artikel : [artikel]?
    var end_time : Int?
    var start_time : Int?
    var comment : String?
    var complete : Bool?
}
struct artikel: Decodable,Encodable{
    var ean : Int?
    var menge: Int?
    var belegt : Int?
    var pickerID : Int?
    var position : String?
    var comment : String?
}

struct bestellugAntwort : Encodable{
    static var bestellungsNr = Int()
    static var bestellugArtikel : [artikel] = []
    static var bestellugEnd_time = Int()
    static var bestellugStart_time = Int()
}




struct liste: Decodable{
    let ean : Int?
    let status : String?
    let position : String?
    let menge: Int?
    
}
struct bestellung : Decodable{
    let Status : String
    let bestellungsNR: String
    let liste : [liste]
}
struct bestellungAPI : Decodable{
    let _created: Int?
    let _id : Int?
    let _update : Int?
    let status : String?
    let bestellungsNr: Int?
    let artikel : [artikel]?
}
