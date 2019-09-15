//
//  CustomCell.swift
//  Player_v3
//
//  Created by Gravman on 9/3/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit

class TableViewCustomCell: UITableViewCell {

    @IBOutlet weak var isFavoriteButton: UIButton!
    
    @IBOutlet weak var fullSongNameLabel: UILabel!
    
    let notifications = NotificationCenter.default
    
    var isSelect = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isFavoriteButton.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @objc func handlePressed() {
        
        isSelect = !isSelect
        isSelect == false ? isFavoriteButton.setImage(UIImage(named: "like-2"), for: .normal) :  isFavoriteButton.setImage(UIImage(named: "like"), for: .normal)
        postNotification()
        
    }
    
    @objc func postNotification() {
        
        let userData: [String: Any] = ["isFavorite": isSelect  , "songName": fullSongNameLabel.text!]
        notifications.post(name: NSNotification.Name.songData, object: self, userInfo: userData)
    
    }
    
}


