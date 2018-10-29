//
//  PlaylistViewController.swift
//  sample_c
//
//  Created by Li heng Ou on 10/26/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: Globle variables
var songs:[String] = []
var audioPlayer = AVAudioPlayer()
var currentPlayingTime = audioPlayer.currentTime
var songDuration = audioPlayer.duration
var index_currentSong = 0
var isFirstTime = true


class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = songs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        do
        {
//            let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".mp3")
//            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
////            audioPlayer.delegate = self
//            songDuration = audioPlayer.duration
//            audioPlayer.play()
            index_currentSong = indexPath.row
            performSegue(withIdentifier: "startGame", sender: self)
        }
        catch
        {
            print ("ERROR: Game not started")
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isFirstTime == true
        {
            gettingSongName()
            isFirstTime = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: playlist functions
    func gettingSongName()
    {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do
        {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songPath
            {
                var mySong = song.absoluteString
                
                if mySong.contains(".mp3")
                {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count - 1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                }
            }
            myTableView.reloadData()
        }
        catch
        {
            
        }
    }
    
    //MARK: button
    //PlayNow
    @IBAction func playSong(_ sender: UIButton) {
        do
        {
            index_currentSong = 0
//            let audioPath = Bundle.main.path(forResource: songs[index_currentSong], ofType: ".mp3")
//            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
////            audioPlayer.delegate = self
//            songDuration = audioPlayer.duration
//            audioPlayer.play()
            performSegue(withIdentifier: "startGame", sender: self)
        }
        catch
        {
            print ("ERROR: Game not started")
        }
    }
    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
//    {
//        print("Song Done Playlist")
//    }
    
    //Back
//    @IBAction func back2Main(_ sender: UIButton) {
//        performSegue(withIdentifier: "backToMain", sender: self)
//    }
    //MARK: Exit
    
    @IBAction func unwindToPlaylistViewController(unwindSegue: UIStoryboardSegue){}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
