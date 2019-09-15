//
//  SongModel.swift
//  Player
//
//  Created by Gravman on 7/31/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//
import UIKit
import AVFoundation

class SongModel {
//    var isFavorite: Bool = false
    var url: URL?
    var title: String? = "Unknown"
    var artwork: UIImage? = UIImage(named: "default-cover")
    var albumName: String? = "Unknown"
    var artist: String? = "Unknown"
    var duration: Float64 = 0
    var fullTrackName: String {
        get {
            return "\(String(describing: artist ?? "")) - \(String(describing: title ?? ""))"
        }
    }
    
    init(withAVPlayerItem item: AVPlayerItem?, url: URL) {
        
        self.url = url
        
        guard let playerItem = item else { return }
        let commonMetadata = playerItem.asset.commonMetadata
        duration = CMTimeGetSeconds(playerItem.asset.duration)
        
        for metadataItem in commonMetadata {
            switch metadataItem.commonKey?.rawValue ?? "" {
            case "title":
                self.title = metadataItem.stringValue
            case "artwork":
                if let imageData = metadataItem.value as? Data {
                    self.artwork = UIImage(data: imageData)
                }
            case "albumName":
                self.albumName = metadataItem.stringValue
            case "artist":
                self.artist = metadataItem.stringValue
            default: break
            }
        }
    }
}
