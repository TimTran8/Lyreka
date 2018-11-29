//
//  OnlineSongsViewController.swift
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 11/18/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit
import AVFoundation

struct SongFile: Decodable
{
    let filename: String
    
}

var song = [SongFile]()




//{"_id":"5bf0b5a46d5f610004290b50","length":5998687,"chunkSize":261120,"uploadDate":"2018-11-18T00:43:21.086Z","filename":"Avicii - Wake Me Up.mp3","md5":"92e526af198a0fa9d55d51a4554f6834","contentType":"audio/mp3"}]

class OnlineSongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDataDelegate {


    @IBOutlet weak var myTableView2: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: OnlineSongsView loaded")
        song = [SongFile]()
        self.getSongName()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myTableView2.reloadData()
        print("Debug: Playlist view will appear")
    }
    

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        return songList.count
        return song.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_online", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell_online2")
        let song_name = song[indexPath.row]
        cell.textLabel?.text = song_name.filename
//        cell.textLabel?.text = songList[indexPath.row]
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = myTableView2.cellForRow(at: indexPath)! as UITableViewCell
        
        let song_to_download = cell.textLabel!.text! as String
        
        download_song(songToDownload: song_to_download)
        
  
    }
    
    
    
    func getSongName()
    {
        print("DEBUG: Loading JSON")

        guard let url = URL(string: "http://lyreka.herokuapp.com/files") else{return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let err = error
                {
                    print("ERROR: Failed to get data from url:", err)
                    return
                }

            guard let data = data else{return}
            
            do
            {
                let decoder = JSONDecoder()
                song = try decoder.decode([SongFile].self, from: data)
                self.myTableView2.reloadData()

                
                for i in song
                {
                    print(i.filename)
                }
                
            }
            catch{print("ERROR:cannot decode")}

            }
        }
        
        
        task.resume()

        for i in song
        {
            print(i.filename)
        }
        
    }
    
    
    
    @IBAction func check(_ sender: UIButton) {
//        let songFileName = "Bohemian Rhapsody.mp3"
        let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let desURL = docDirURL.appendingPathComponent(songFileName)
//
//        //check file exists
//        if FileManager.default.fileExists(atPath: desURL.path)
//        {
//            print("DEBUG: File is downloaded at %@", desURL.path)
//        }
//        else
//        {
//            print("DEBUG: File is not saved")
//        }
//        //check the size
//        do
//        {
//            let fileAttr = try FileManager.default.attributesOfItem(atPath: desURL.path)
//            let fileSize = fileAttr[FileAttributeKey.size] as! UInt64
//            print("DEBUG: Download file size = %@", fileSize)
//        }
//        catch{print("ERROR: something goes wrong")}
//
//        //play the song
//        do {
//            let player = try AVAudioPlayer(contentsOf: desURL)
//
//            player.volume = 1.0
//            player.prepareToPlay()
//            print("DEBUG: Song duration = " + String(player.duration))
//            player.play()
//            while(player.isPlaying)
//            {
//                print("DEBUG: Song is playing, " + String(player.currentTime))
//                sleep(1)
//            }
//            print("DEBUG: Song Done")
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
        //check lyrics exist
        let lyricsFileName = "Bohemian Rhapsody.lrc"
        let lrcURL = docDirURL.appendingPathComponent(lyricsFileName)
        if FileManager.default.fileExists(atPath: lrcURL.path)
        {
            print("DEBUG: File is downloaded at %@", lrcURL.path)
        }
        else
        {
            print("DEBUG: File is not saved")
        }
        //check the size
        do
        {
            let fileAttr = try FileManager.default.attributesOfItem(atPath: lrcURL.path)
            let fileSize = fileAttr[FileAttributeKey.size] as! UInt64
            print("DEBUG: Download file size = %@", fileSize)
        }
        catch{print("ERROR: something goes wrong")}
        
        do
        {
            let fullText = try String(contentsOfFile: lrcURL.path, encoding: .utf8)
            print(fullText)
        }
        catch { print("DEBUG: Failed to read lyrics") }

        

        
    }
    
    func isSongExist(songName: String) -> Bool
    {
        var searchSong = songName
        if searchSong.contains(".mp3")
        {
            searchSong = searchSong.replacingOccurrences(of: ".mp3", with: "")
        }

        //Search the document directory
        let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        searchSong = searchSong + ".mp3"
        let desURL = docDirURL.appendingPathComponent(searchSong)
        
        if FileManager.default.fileExists(atPath: desURL.path)
        {
            print("DEBUG: " + searchSong + " is exist in " + desURL.path)
            return true
        }
        
        //Search the bundle
        let bundle_path = Bundle.main.path(forResource: searchSong, ofType: ".mp3")
        
        if bundle_path != nil
        {
            for i in songs
            {
                if i.contains(searchSong)
                {
                    print("DEBUG: " + searchSong + " is exist in " + bundle_path!)
                    return true
                }
            }
            
            //            print("DEBUG: " + searchSong + " is exist in " + bundle_path!)
            //            return true
        }
        
        print("DEBUG: " + searchSong + " does not exist")
        return false
    }
    
    func download_song(songToDownload: String)
    {
        print("DEBUG: Prepare to download " + songToDownload)
        let songFileName = songToDownload
        let song_to_download = songToDownload.replacingOccurrences(of: " ", with: "%20")
        let download_url = "https://lyreka.herokuapp.com/files/" + song_to_download
        print("DEBUG: Getting song from:" + download_url)
        
        if let dl_url = URL(string: download_url)
        {
            //Check if song exists
            if isSongExist(songName: songFileName)
            {
                print("DEBUG: File already exists")
            }
            else
            {

                //Using downloadTask2
                let request = URLRequest(url: dl_url)
                let task = URLSession.shared.downloadTask(with: request){ (location, response, error) in
                    if let location = location, error == nil
                    {
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode
                        {
                            print("DEBUG: HTTP status: \(statusCode)")
                        }
                        
                        do
                        {
                            let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let desURL = docDirURL.appendingPathComponent(songFileName)
                            print("DEBUG: Download song to: %@", desURL)
                            try FileManager.default.moveItem(at: location, to: desURL)
                            //check the size
                            let fileAttr = try FileManager.default.attributesOfItem(atPath: desURL.path)
                            let fileSize = fileAttr[FileAttributeKey.size] as! UInt64
                            print("DEBUG: Song file size = %@", fileSize)
                            print("DEBUG: Download successfully")
                            
                            songs.append(songFileName.replacingOccurrences(of: ".mp3", with: ""))
                            songsPath.append(desURL.absoluteString)
                            playlistSync()
                        }catch(let writeError)
                        {
                            print("ERROR: failed to create file With error: \(writeError) ")
                        }
                    }
                    else
                    {
                        print("ERROR: failed to download the file. Error: %@", error!.localizedDescription);
                    }
                }
                task.resume()
                
                get_lyrics(songToDownload: song_to_download)
                
            }
        }
        else
        {
            print("ERROR: Cannot get the download url")
        }
        
    }
    
    
    func get_lyrics(songToDownload: String)
    {
        print("DEBUG: getting lyrics...")
        var songName = songToDownload.replacingOccurrences(of: ".mp3", with: "")
        songName  = songName.replacingOccurrences(of: " ", with: "%20")
        let download_path = "https://lyreka.herokuapp.com/getlyrics/" + songName
        print("DEBUG: download path: " + download_path)
        let download_url = URL(string: download_path)
        print("DEBUG: Searching lyrics from %@", download_url!)
        
        
//        let task = URLSession.shared.dataTask(with: download_url) { (data, response, error) in
        let task = URLSession.shared.dataTask(with: download_url!) {(data, response, error) in
            DispatchQueue.main.async {
                if let err = error
                {
                    print("ERROR: Failed to get data from url:", err)
                    return
                }
                
                guard let data = data else{return}
                let outputStr  = String(data: data, encoding: String.Encoding.utf8) as String!
//                print(outputStr!)
                
                let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let lrcFileName = songName.replacingOccurrences(of: "%20", with: " ") + ".lrc"
                let desURL = docDirURL.appendingPathComponent(lrcFileName)
                print("DEBUG: Download lyrics to: %@", desURL)
                do
                {
                    try data.write(to: desURL)
                }catch { print("ERROR: Writing file: \(error)") }
                
                
            }
        }
        
        
        task.resume()

        
    }
    
    
    
}
