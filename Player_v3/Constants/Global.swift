//
//  Global.swift
//  Player
//
//  Created by Gravman on 7/31/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//
import Foundation
import AVFoundation

class Global {
    
    static var auPlayer = AVAudioPlayer()
    static var playlist: [SongModel] = []
    static var playlistVar: [SongModel] = []
    static var currentSong: Int = 0
    static var musicIsPlaying: Bool = false
    static var shuffleMode: Bool = false
    static var repeatMode: Bool = false
    static var isFavorite: Bool = false
    

    func createPl() {
        
        let folderURL = Bundle.main.paths(forResourcesOfType: nil, inDirectory: "Music")
        
        for song in folderURL {
            let songPath = URL(fileURLWithPath: song)
            let avplayerItem = AVPlayerItem(url: songPath)
            let itemOfPlaylist = SongModel(withAVPlayerItem: avplayerItem, url: songPath)
            Global.playlist.append(itemOfPlaylist)
        }
    }
}


