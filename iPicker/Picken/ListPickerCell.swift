//
//  ListPickerCell.swift
//  iPicker
//
//  Created by Osman A on 24.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class ListPickerCell: UITableViewCell {
    
    @IBOutlet weak var PickID: UILabel!
    
    @IBOutlet weak var totalCount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
