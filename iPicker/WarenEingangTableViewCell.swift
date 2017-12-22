//
//  WarenEingangTableViewCell.swift
//  iPicker
//
//  Created by Osman Ashraf on 29.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class WarenEingangTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Position: UILabel!
    
    @IBOutlet weak var Ean: UILabel!
    
    @IBOutlet weak var menge: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        status.layer.masksToBounds = true
        status.layer.cornerRadius = status.frame.width/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
