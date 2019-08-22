//
//  Global.swift
//  Player
//
//  Created by Gravman on 7/31/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//
import Foundation
import AVFoundation

var auPlayer = AVAudioPlayer()
var playlist: [Song] = []
var playlistVar: [Song] = []
var songNames: [String] = []    // works with SearchBar
var currentSongNames: [String] = []    // playlistTable uses this array to display data
var currentSong: Int = 0
var musicIsPlaying: Bool = false
var shuffleMode: Bool = false
var repeatMode: Bool = false
