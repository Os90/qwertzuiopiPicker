//
//  PickerTableViewCell.swift
//  iPicker
//
//  Created by Osman A on 17.11.17.
//  Copyright © 2017 Osman Ashraf. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var PositionLabel: UILabel!
    
    @IBOutlet weak var EanLabel: UILabel!
    
    @IBOutlet weak var CountLabel: UILabel!
    
    @IBOutlet weak var StatusImg: UIImageView!
    
    @IBOutlet weak var editImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = UITableViewCellSelectionStyle.none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeColorToGray(){
        PositionLabel.textColor = UIColor.gray
        EanLabel.textColor = UIColor.gray
        CountLabel.textColor = UIColor.gray
    }
    
    func changeColorToblack(){
        PositionLabel.textColor = UIColor.black
        EanLabel.textColor = UIColor.black
        CountLabel.textColor = UIColor.black
    }

}
