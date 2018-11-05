//
//  File:       PlaylistViewController.swift
//  Purpose:    This file is the view controller for the playlist which displays all the songs in the local library
//  Project:    Lyreka_xcodeProject
//  Group:      Lyreka CMPT275-FALL18-Group08
//  For the contributors, changes, and bugs of this file, please refer to https://github.com/TimTran8/CMPT275Group8
//
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 10/26/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: Globle variables
var songs:[String] = [] //Store the song names from the local library
var index_currentSong = 0 //The index of the song selected in the songs[]
var audioPlayer = AVAudioPlayer() //The audioPlayer to play the song selected
var currentPlayingTime = audioPlayer.currentTime //Read the current timestamp when song is being played
var songDuration = audioPlayer.duration //Read the total duration of the song

var isFirstTime = true //Set true when the audio player runs in the first time
var isGameEnd = false //Set true when the song ends

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Variables
    
    //Variable: myTableView
    //Description: The table view will show the playlist with the song names
    @IBOutlet weak var myTableView: UITableView!
    
    //Force landscape
    
    //Variable: supportedInterfaceOrientations
    //Description: Set UI orientation to landscapeLeft
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    //Variable: shouldAutorotate
    //Description: UI should be rotated automatically
    override var shouldAutorotate: Bool {
        return true
    }
    
    //MARK: Functions
    
    //Function: tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    //Input:    [1]tableView
    //          [2]numberOfRowsInSection
    //Output:   songs.count:Int return the number of songs in the playlist
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }
    
    //Function: tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    //Input:    [1]tableView
    //          [2]cellForRowAt indexPath
    //Output:   cell:UITableViewCell
    //Description:  Display the song names for each cell in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = songs[indexPath.row]
        return cell
    }
    
    //Function: tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //Input:    [1]tableView
    //          [2]indexPath indexPath
    //Description:  Get the selected song index and navigate to the Game view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            index_currentSong = indexPath.row
            performSegue(withIdentifier: "startGame", sender: self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFirstTime == true
        {
            gettingSongName()
            isFirstTime = false
        }
        isGameEnd = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Function: gettingSongName()
    //Description:  Load the song names into the variable songs[] from the local library
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
            print("ERROR: Cannot load the songs from local library")
        }
    }
    
    //Function: playSong(_ sender: UIButton)
    //Description:  Navigate to the Game View
    @IBAction func playSong(_ sender: UIButton) {
        index_currentSong = 0

        performSegue(withIdentifier: "startGame", sender: self)

    }
    

    //MARK: Exit
    //Function: unwindToPlaylistViewController(unwindSegue: UIStoryboardSegue)
    //Description:  This funcion can be called by any view that will return to the Playlist view
    @IBAction func unwindToPlaylistViewController(unwindSegue: UIStoryboardSegue){}



}
