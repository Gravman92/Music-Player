//
//  ListVC.swift
//  Player_v3
//
//  Created by Gravman on 8/2/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import MobileCoreServices


class ListVC: UIViewController {
    var updater: CADisplayLink!


//    var favoritePlaylist: [SongModel] = FavoriteVC.createFavoritePl(SongModel)
    
    @IBOutlet weak var playlistTable: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchOut: UIBarButtonItem!
    
    let notification = NotificationCenter.default
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpdater()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatingPlaylist()
        managers ()
        background()
        searchBar.delegate = self
        addObserver()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updater.invalidate()
    }
    
    
        // MARK: - Metods
    
    func addObserver() {
        notification.addObserver(self, selector: #selector(handleHotification), name: NSNotification.Name.songData, object: nil)
    }
    
    @objc func handleHotification(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as NSDictionary? {
            guard let songName = userInfo["songName"] as? String else { return }
            guard let isFavorite = userInfo["isFavorite"] as? Bool else { return }
            saveData(songName: songName, isFavorite: isFavorite)
            print(songName, isFavorite)
        }
        
    }
    
    func saveData(songName: String, isFavorite: Bool) {
        let context = CoreDataSingleton.shared.persistentContainer.viewContext
        
        let cont = NSEntityDescription.insertNewObject(forEntityName: "Songs", into: context)
        cont.setValue(songName, forKey: "songName")
        cont.setValue(isFavorite, forKey: "isFavorite")
        
        do {
            try context.save()
            
        } catch {
            print ("Error")
        }
    }
    

    
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    func creatingPlaylist () {
        
        let folderURL = Bundle.main.paths(forResourcesOfType: nil, inDirectory: "Music")

        for song in folderURL {
            let songPath = URL(fileURLWithPath: song)
            let avplayerItem = AVPlayerItem(url: songPath)
            let itemOfPlaylist = SongModel(withAVPlayerItem: avplayerItem, url: songPath)
            Global.playlist.append(itemOfPlaylist)
        }
    }
    
    func background() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {}
    }
    
    func managers () {
        Global.playlistVar = Global.playlist
    }
    
    func setUpdater() {
        updater = CADisplayLink(target: self, selector: #selector(updatingCell))
        updater.preferredFramesPerSecond = 1
        updater.add(to: .current, forMode: .default)
    }
    @objc func updatingCell () {
        var index = 0
        var actualIndex: Int?
        for song in Global.playlistVar {
            if song.fullTrackName == Global.playlist[Global.currentSong].fullTrackName {
                actualIndex = index
                break
            } else {
                index += 1
                actualIndex = nil
            }
            if actualIndex != nil {
                let selectIndex = IndexPath(row: actualIndex!, section: 0)
                playlistTable.selectRow(at: selectIndex, animated: true, scrollPosition: .none)
            }
        }
    }
    
    
    @IBAction func searchBut(_ sender: UIButton) {
  
    }
    
    deinit {
        
        notification.removeObserver(self)
        
    }
    
}
extension ListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.playlistVar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCustomCell
        cell.fullSongNameLabel.text = Global.playlistVar[indexPath.row].fullTrackName
        cell.isFavoriteButton.tag = indexPath.row

        return cell
    }
    
}

extension ListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try Global.auPlayer = AVAudioPlayer(contentsOf: Global.playlistVar[indexPath.row].url!)
            
            var index = -1
            
            for song in Global.playlist {
                index += 1
                if song.fullTrackName == Global.playlistVar[indexPath.row].fullTrackName {
                    Global.currentSong = index
                    break
                }
            }
            
            Global.musicIsPlaying = true
            Global.auPlayer.play()
            playlistTable.reloadData()
        } catch {
            print("Error!")
        }
    }
}
extension ListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            Global.playlistVar = Global.playlist
            playlistTable.reloadData()
            return
        }
        Global.playlistVar = Global.playlist.filter({ song -> Bool in
            return song.fullTrackName.lowercased().contains(searchText.lowercased())
        })
        playlistTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

//extension ListVC: UITableViewDragDelegate {
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        return
//    }
//
//
//}
//
//extension ListVC: UITableViewDropDelegate {
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//
//    }
//
//
//}
