//
//  FavoriteVC.swift
//  Player_v3
//
//  Created by Gravman on 8/22/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit
import AVFoundation

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var myFavoriteTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFavoriteTable.isEditing = true
        

    }
    @IBAction func editAction(_ sender: Any) {
        
    }
    
}
extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myFavoriteTable.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! CustomCell
        cell.cellLabel.text = favoritePlaylist[indexPath.row].fullTrackName
        return cell
    }
    
    
}

extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try auPlayer = AVAudioPlayer(contentsOf: favoritePlaylist[indexPath.row].url!)
            
            var index = -1
            
            for song in favoritePlaylist {
                index += 1
                if song.fullTrackName == favoritePlaylist[indexPath.row].fullTrackName {
                    currentSong = index
                    break
                }
            }
            
            musicIsPlaying = true
            auPlayer.play()
            myFavoriteTable.reloadData()
        } catch {
            print ("Error")
        }
    }
}
