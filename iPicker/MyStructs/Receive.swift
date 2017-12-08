//
//  Receive.swift
//  iPicker
//
//  Created by Osman Ashraf on 02.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import Foundation

struct antwort : Decodable{
    let num_results:Int?
    let page: Int?
    let total_pages: Int?
    var objects : [objects]?
}
struct objects : Decodable{
    let _created: Int?
    let _id : Int?
    let _update : Int?
    let status : String?
    let bestellungsNr: Int?
    let artikel : [artikel]?
    let end_time : Int?
    let start_time : Int?
}
struct artikel: Decodable{
    var ean : Int?
    var menge: Int?
    var belegt : Int?
    var pickerID : Int?
    var position : String?
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
