//
//  CustomCell.swift
//  Player_v3
//
//  Created by Gravman on 9/3/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var cellBut: UIButton!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteBut(_ sender: UIButton) {
        if cellBut.isSelected == false {
            cellBut.imageView?.image = UIImage(named: "like-2")
        } else {
            cellBut.imageView?.image = UIImage(named: "like")
        }
    }
    
}
