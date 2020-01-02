//
//  PlayerVC.swift
//  Player_v3
//
//  Created by Gravman on 8/2/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerVC: UIViewController{

    @IBOutlet weak var songFullName: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var playerTime: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playPause: UIButton!
    
    var updater: CADisplayLink!
//    var global = Global()
    var list = ListVC()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpdater()
        
        print(Global.currentSong)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaulSong()
        backgroundMusic()
        setupRemoteTransportControls()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updater.invalidate()
        
    }
    //MARK: - Metods
    
    func defaulSong() {
        
        if Global.musicIsPlaying == false{
            do {
                if Global.currentSong < Global.playlist.count {
                    guard let url = Global.playlist[Global.currentSong].url else { return }
                    try Global.auPlayer = AVAudioPlayer(contentsOf: url)
                }
            } catch {
                print("Error")
            }
        }
    }
    
    func setUpdater () {
        updater = CADisplayLink(target: self, selector: #selector(updatingItems))
        updater?.preferredFramesPerSecond = 1
        updater?.add(to: .current, forMode: .default)

    }
    @objc func updatingItems (){
        songName.text = Global.playlist[Global.currentSong].title
        songFullName.text = Global.playlist[Global.currentSong].fullTrackName
        Global.auPlayer.delegate = self as AVAudioPlayerDelegate
        albumCover.image = Global.playlist[Global.currentSong].artwork
        progressSlider.setValue(Float(Global.auPlayer.currentTime), animated: true)
        progressSlider.maximumValue = Float(Global.auPlayer.duration)
        
        let currentTime = Int(Global.auPlayer.currentTime)
        let minutesTime = currentTime / 60
        let secondsTime = currentTime - minutesTime * 60
        playerTime.text = NSString(format: "%02d:%02d", minutesTime, secondsTime) as String
        let currentTimeDur = Int(Global.auPlayer.duration)
        let minutesDur = currentTimeDur / 60
        let secondsDur = currentTimeDur - minutesDur * 60
        durationTime.text = NSString(format: "%02d:%02d", minutesDur, secondsDur) as String
        if Global.auPlayer.isPlaying {
            playPause.setImage(UIImage(named: "2"), for: .normal)
        } else {
            playPause.setImage(UIImage(named: "1"), for: .normal)
        }
        
    }
    func backgroundMusic() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch {}
    }
    func setupRemoteTransportControls() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(playControlCenter))
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(pauseControlCenter))
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(nextControlCenter))
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(prevControlCenter))
    }
    
    @objc func playControlCenter() {
        Global.auPlayer.play()
    }
    
    @objc func pauseControlCenter() {
        Global.auPlayer.pause()
    }
    
    @objc func nextControlCenter() {
        nextSong()
    }
    
    @objc func prevControlCenter() {
        prevSong()
    }
    
    func prevSong() {
        Global.auPlayer.stop()
        Global.musicIsPlaying = false
        Global.currentSong -= 1
        
        if Global.currentSong < 0 {
            Global.currentSong = Global.playlist.count - 1
        }
        do {
            if Global.currentSong < Global.playlist.count {
                guard let url = Global.playlist[Global.currentSong].url else { return }
                try Global.auPlayer = AVAudioPlayer(contentsOf: url)
            }
                
        } catch {
            print ("Error")
        }
        Global.auPlayer.play()
    }
    func nextSong() {
        Global.auPlayer.stop()
        Global.musicIsPlaying = false
        Global.currentSong += 1
        if Global.currentSong >= Global.playlist.count {
            Global.currentSong = 0
        }
        do {
            if Global.currentSong < Global.playlist.count {
                guard let url = Global.playlist[Global.currentSong].url else { return }
                try Global.auPlayer = AVAudioPlayer(contentsOf: url)
            }
        } catch {
            print("Error")
        }
        Global.auPlayer.play()
    }
    
    //MARK: - Action
    
    @IBAction func playPauseBut(_ sender: UIButton) {
        if Global.auPlayer.isPlaying {
            Global.musicIsPlaying = false
            Global.auPlayer.pause()
        } else {
            Global.musicIsPlaying = true
            Global.auPlayer.play()
        }
    }
    
    @IBAction func stopBut(_ sender: UIButton) {
        Global.auPlayer.stop()
        Global.auPlayer.currentTime = 0
    }
    
    @IBAction func prevBut(_ sender: UIButton) {
        prevSong()
    }
    
    @IBAction func nextBut(_ sender: UIButton) {
        nextSong()
    }
    
    @IBAction func timeIntervalSlider(_ sender: UISlider) {
        Global.auPlayer.currentTime = TimeInterval(progressSlider.value)
    }
}

extension PlayerVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextSong()
            Global.musicIsPlaying = true
            Global.auPlayer.play()
        }
    }
}
