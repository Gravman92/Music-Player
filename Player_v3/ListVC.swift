//
//  ListVC.swift
//  Player_v3
//
//  Created by Gravman on 8/2/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit
import AVFoundation

class ListVC: UIViewController {
    var updater: CADisplayLink! = nil
    
    @IBOutlet weak var playlistTable: UITableView!
    
    @IBOutlet weak var navigationBarItem: UINavigationBar!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updater.invalidate()
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = playlistVar[indexPath.row].fullTrackName
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
