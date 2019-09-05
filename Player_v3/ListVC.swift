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

class ListVC: UIViewController {
    var updater: CADisplayLink! = nil
    
    @IBOutlet weak var playlistTable: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchOut: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpdater()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPress()
        creatingPlaylist()
        managers ()
        background()
        searchBar.delegate = self
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updater.invalidate()
    }
    
    // MARK: - Metods
    func longPress () {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
    }
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    func creatingPlaylist () {
        let folderURL = Bundle.main.paths(forResourcesOfType: nil, inDirectory: "Music")
        
        for song in folderURL {
            let songPath = URL(fileURLWithPath: song)
            let avplayerItem = AVPlayerItem(url: songPath)
            let itemOfPlaylist = Song(withAVPlayerItem: avplayerItem, url: songPath)
            playlist.append(itemOfPlaylist)
        }
    }
    
    func background() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {}
    }
    
    func managers () {
        playlistVar = playlist
    }
    
    func setUpdater() {
        updater = CADisplayLink(target: self, selector: #selector(updatingCell))
        updater.preferredFramesPerSecond = 1
        updater.add(to: .current, forMode: .default)
    }
    @objc func updatingCell () {
        var index = 0
        var actualIndex: Int?
        for song in playlistVar {
            if song.fullTrackName == playlist[currentSong].fullTrackName {
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
    
}
extension ListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistVar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.cellLabel.text = playlistVar[indexPath.row].fullTrackName
        cell.cellBut.tag = indexPath.row
        if cell.cellBut.isSelected{
            cell.cellBut.imageView?.image = UIImage(named: "like")
            isFavorite = true
        } else {
            cell.cellBut.imageView?.image = UIImage(named: "like-2")
            isFavorite = false
        }
        return cell
    }
    
}

extension ListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try auPlayer = AVAudioPlayer(contentsOf: playlistVar[indexPath.row].url!)
            
            var index = -1
            
            for song in playlist {
                index += 1
                if song.fullTrackName == playlistVar[indexPath.row].fullTrackName {
                    currentSong = index
                    break
                }
            }
            
            musicIsPlaying = true
            auPlayer.play()
            playlistTable.reloadData()
        } catch {
            print("Error!")
        }
    }
}
extension ListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            playlistVar = playlist
            playlistTable.reloadData()
            return
        }
        playlistVar = playlist.filter({ song -> Bool in
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


