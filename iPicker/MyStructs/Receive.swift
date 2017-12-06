//
//  Receive.swift
//  iPicker
//
//  Created by Osman Ashraf on 02.12.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import Foundation


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
