//
//  FavoriteVC.swift
//  Player_v3
//
//  Created by Gravman on 8/22/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var myFavoriteTable: UITableView!
    
    @IBOutlet weak var editOut: UIButton!
    
    
    var favoritePlaylist: [Songs] = []
    var model: [Songs] = []
    var edit: Bool = false
    let fetch = CoreDataManager()
    

    
    func createFavoritePl(with model: [Songs]) {
        
        let songName = model.map{ return $0.songName}
        fetch.fetchData(songName: "", isFavorite: true)
        myFavoriteTable.reloadData()
        
    }

    func fetchSongs() {
        
        let context = CoreDataSingleton.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Songs>(entityName: "Songs")
        
        do {
            
            let songs = try context.fetch(fetchRequest)
            
//            songs.forEach { (song) in
//                if model.contains(song) == isFavorite {
//
//                    print("DoubleSong")
//
//                } else {
//
//                    model.append(song)
//                }
//            }
            
            let favoriteSongs = songs.filter { song -> Bool in
                return !song.isFavorite
            }
            
            model.append(contentsOf: favoriteSongs)
            
            createFavoritePl(with: model)
            
        } catch let err {
            
            print(err)
        }
        
    }
    
    func deleteData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        myFavoriteTable.isEditing = true
//        isFavorite = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myFavoriteTable.delegate = self
        myFavoriteTable.dataSource = self
        fetchSongs()
//        ListVC.updateData(song)
//        editOut.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
        
    }
    
    @objc func handlePressed() {
        
        
        
    }
    @IBAction func editAction(_ sender: Any) {
        
        myFavoriteTable.setEditing(!myFavoriteTable.isEditing, animated: true)
        
    }
    
}
extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellFav = myFavoriteTable.dequeueReusableCell(withIdentifier: "cellFav", for: indexPath) as! TableViewCustomCell
        cellFav.textLabel?.text =  model[indexPath.row].songName
        return cellFav
    }
    
}

extension FavoriteVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        do {
//            favoritePlaylist = model
//            try auPlayer = AVAudioPlayer(contentsOf: favoritePlaylist[indexPath.row].songName)
//
//            var index = -1
//
//            for song in favoritePlaylist {
//                index += 1
//                if song.fullTrackName == favoritePlaylist[indexPath.row].fullTrackName {
//                    currentSong = index
//                    break
//                }
//            }
//
//            musicIsPlaying = true
//            auPlayer.play()
//            myFavoriteTable.reloadData()
//        } catch {
//            print ("Error")
//        }
//    }
}
