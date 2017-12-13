//
//  Global.swift
//  iPicker
//
//  Created by Osman Ashraf on 19.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import Foundation

struct Picklist : Codable {
    var id = Int()
    var ean = String()
    var position = String()
    var time = String()
    var menge = Int()
    
    static var myArray:[Picklist] = []
    static var WarenEingang : antwort?

    static var durchlaufAuftrage = 0
    static var durchlaufBestellungen = 0
    
    static var sessionObject : objects?
}


