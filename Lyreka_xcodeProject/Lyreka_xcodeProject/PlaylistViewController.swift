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
var songsPath:[String] = [] //Strore the .mp3 file path
var index_currentSong = 0 //The index of the song selected in the songs[]
var audioPlayer = AVAudioPlayer() //The audioPlayer to play the song selected
//var currentPlayingTime = audioPlayer.currentTime //Read the current timestamp when song is being played
var currentPlayingTime = TimeInterval.init()
var songDuration = audioPlayer.duration //Read the total duration of the song

//var highScores:[Int] = [] //Store the high score for each song in the playlist

var isFirstTime = true //Set true when the audio player runs in the first time
var isGameEnd = false //Set true when the song ends

func playlistSync()
{
    UserDefaults.standard.set(songs, forKey: "myPlaylist")
    UserDefaults.standard.set(songsPath, forKey: "mySongsPath")
//    UserDefaults.standard.set(highScores, forKey: "myHighScores")
    print("DEBUG: Sync Done")
}



class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Variables
    
    //Variable: myTableView
    //Description: The table view will show the playlist with the song names
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var edit_button: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var header_background: UIImageView!
    @IBOutlet weak var choose_a_song: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    
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
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaylistCell
        cell.textLabel?.text = songs[indexPath.row]
        cell.textLabel?.textAlignment = .center
//        cell.highScore_label.text = String(highScores[indexPath.row])
        
        //set background of cell
        let image : UIImage = UIImage(named: Theme.cellBackground)!
        let cell_bg = UIImageView(image: image)
        cell.backgroundView = cell_bg
        
        //set cell font and color
        cell.textLabel?.font = UIFont(name: Theme.mainFontName, size: 32)
        cell.textLabel?.textColor = Theme.mainFontColor
        
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if myTableView.isEditing
        {
            return .delete
        }
        return .none
    }
    
    //Function: tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    //Description: Delete a row in the table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            deleteSong(index: indexPath.row)
            songs.remove(at: indexPath.row)
            songsPath.remove(at: indexPath.row)
//            highScores.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            playlistSync()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = songs[sourceIndexPath.row]
        let tmp_path = songsPath[sourceIndexPath.row]
        songs.remove(at: sourceIndexPath.row)
        songsPath.remove(at: sourceIndexPath.row)
        songs.insert(tmp, at: destinationIndexPath.row)
        songsPath.insert(tmp_path, at: destinationIndexPath.row)
        
//        let tmp2 = highScores[sourceIndexPath.row]
//        highScores.remove(at: sourceIndexPath.row)
//        highScores.insert(tmp2, at: destinationIndexPath.row)
        playlistSync()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFirstTime == true
        {
            gettingSongName()
            isFirstTime = false
        }
        isGameEnd = false
        
        print("DEBUG: Playlist view loaded")
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        bg.image = UIImage(named: Theme.mainBackground)!
        bg.contentMode = UIViewContentMode.scaleAspectFill
        bg.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bg.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.sendSubview(toBack: bg)
        
        header_background.image = UIImage(named: Theme.tableTop)
        
        choose_a_song.font = UIFont(name: Theme.titleFontName, size: 62)
        choose_a_song.textAlignment = .center
        
        if UIFont(name: Theme.mainFontName, size: 22) != nil {
            edit_button.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 22)
        }
        edit_button.setBackgroundImage(UIImage(named: Theme.bigButton), for: UIControlState.normal)
        edit_button.titleLabel?.textColor = Theme.mainFontColor
        if UIFont(name: Theme.mainFontName, size: 22) != nil {
            back.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 22)
        }
        back.setBackgroundImage(UIImage(named: Theme.bigButton), for: UIControlState.normal)
        back.titleLabel?.textColor = Theme.mainFontColor
        
        //removes 35px space at top of table
        myTableView.tableHeaderView = nil
        
        myTableView.backgroundColor = UIColor.clear
        myTableView.isOpaque = false
        myTableView.backgroundView = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
        print("Debug: Playlist view will appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //Function: gettingSongName()
    //Description:  Load the song names into the variable songs[] from the local library
    func gettingSongName()
    {
        songs = UserDefaults.standard.array(forKey: "myPlaylist") as? [String] ?? [String]()
        songsPath = UserDefaults.standard.array(forKey: "mySongsPath") as? [String] ?? [String]()
//        highScores = UserDefaults.standard.array(forKey: "myHighScores") as? [Int] ?? [Int]()
        if songs.isEmpty == false
        {
            return
        }
        
        let localFolderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        let downloadedFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do
        {
            let songPath = try FileManager.default.contentsOfDirectory(at: localFolderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song in songPath
            {
                var mySong = song.absoluteString
                
                if mySong.contains(".mp3")
                {
                    print("DEBUG: Adding song to playlist: " + mySong)
                    songsPath.append(mySong)
                    print("DEBUG: SongPath[0] = %@", songsPath[0])
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count - 1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                    
//                    highScores.append(0)
                }
            }
            
            let songPath2 = try FileManager.default.contentsOfDirectory(at: downloadedFileURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song2 in songPath2
            {
                print(song2)
                var mySong = song2.absoluteString

                if mySong.contains(".mp3")
                {
                    songsPath.append(mySong)
                    print(mySong)
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count - 1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)

                    //                    highScores.append(0)
                }
            }
            playlistSync()
            myTableView.reloadData()
        }
        catch
        {
            print("ERROR: Cannot load the songs from local library")
        }
    }
    
    func deleteSong(index: Int)
    {
        let filePath = songsPath[index]
        let fileURL = NSURL(string: filePath)! as URL
        var lrcPath = songsPath[index]
        lrcPath = lrcPath.replacingOccurrences(of: ".mp3", with: ".lrc")
        let lrcURL = NSURL(string: lrcPath)! as URL
        
        do
        {
            print("DEBUG: Deleting \(fileURL)")
            try FileManager.default.removeItem(at: fileURL)
            print("DEBUG: Deleting \(lrcURL)")
            try FileManager.default.removeItem(at: lrcURL)
        } catch {
            print("Could not delete the file: \(error)")
        }
    }

    
    //Function: playSong(_ sender: UIButton)
    //Description:  Navigate to the Game View
//    @IBAction func playSong(_ sender: UIButton) {
//        index_currentSong = 0
//
//        performSegue(withIdentifier: "startGame", sender: self)
//
//    }
    
    
    @IBAction func editPlaylist(_ sender: UIButton) {
        if myTableView.isEditing == false
        {
            myTableView.isEditing = true
            edit_button.setTitle("Done", for: .normal)
            
        }
        else
        {
            myTableView.isEditing = false
            edit_button.setTitle("Edit", for: .normal)
        }
    }
    

    //MARK: Exit
    //Function: unwindToPlaylistViewController(unwindSegue: UIStoryboardSegue)
    //Description:  This funcion can be called by any view that will return to the Playlist view
    @IBAction func unwindToPlaylistViewController(unwindSegue: UIStoryboardSegue){}



}
