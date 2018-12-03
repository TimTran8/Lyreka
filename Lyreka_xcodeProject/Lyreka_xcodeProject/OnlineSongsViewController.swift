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


class OnlineSongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDataDelegate {


    @IBOutlet weak var myTableView2: UITableView!
    
    @IBOutlet weak var download_label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: OnlineSongsView loaded")
        song = [SongFile]()
        self.getSongName()
        download_label.text = ""
        
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
        download_label.text = "Downloading mp3..."
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
        download_label.text = "Downloading lyrics..."
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
                let rowLyrics  = String(data: data, encoding: String.Encoding.utf8)! as String
                print(rowLyrics)
                let outputLyrics = self.parse_lyrics(input: rowLyrics)
                
                
                let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let lrcFileName = songName.replacingOccurrences(of: "%20", with: " ") + ".lrc"
                let desURL = docDirURL.appendingPathComponent(lrcFileName)
                print("DEBUG: Download lyrics to: %@", desURL)
                self.download_label.text = ""
                do
                {
                    try outputLyrics.write(to: desURL, atomically: false, encoding: .utf8)
//                    try data.write(to: desURL)
                }catch { print("ERROR: Writing file: \(error)") }
                
                
            }
        }
        
        
        task.resume()

        
    }
    
    
    func parse_lyrics(input:String)->String
    {
        var result = ""
        print("DEBUG: Parsing lyrics...")

        var good_input = ""

        var raw_input = input.components(separatedBy: "\n")
        for i in 0..<raw_input.count
        {
            var tmp = raw_input[i]
            if tmp.contains("][")
            {
                //Get the substring
                let lyrics_index = tmp.lastIndex(of: "]")
                let lyrics_tmp = tmp[(lyrics_index!)..<tmp.endIndex] + "\n"
                tmp = tmp.replacingOccurrences(of: "]", with: lyrics_tmp)
            }

            good_input += tmp + "\n"
        }

        var full_text = good_input.components(separatedBy: "\n")
        full_text = full_text.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        for i in 0..<full_text.count
        {
            if full_text[i].contains("[0")
            {
                var line = full_text[i]
                line = line.replacingOccurrences(of: "[", with: "")
                line = line.replacingOccurrences(of: "]", with: "\t")
                
                let line_components = line.components(separatedBy: "\t")
                let timestamp_line = line_components[0]
                var lyrics_str = line_components[1]
                
                
                line = ""
                //Parse timestamp
                let timestamp_str = timestamp_line.components(separatedBy: ":")
                let timestamp_float = Float(timestamp_str[0])! * 60.0 + Float(timestamp_str[1])!
                line += String(timestamp_float) + "\t"
                //Parse lyrics
                lyrics_str += "\ta\tb\tc\td\n"
                line += lyrics_str
                //Output timestamp and lyrics in this line
                result += line
            }
        }
        
        result = generate_question(input: result)
        
        print(result)
        return result;
    }
    
    
    func generate_question(input: String)-> String
    {

        print("DEBUG: Generating question...\n")
        var result = ""
        let options_base:[String] = ["\ttight\thurt\tdifference","\tslow\tpull\tlisten","\tbad\tfail\tfaith","\tfar\tsharp\tgift","\trare\tshare\ttell","\tlight\twell\tcool","\tpast\teagle\tvoice","\tnight\tdish\ttail","\tman\tcall\thope","\tnote\tsave\tfinal"]
        var raw_input = input.components(separatedBy: "\n")
        
        let num_question = raw_input.count / 4
        
        for i in 0..<raw_input.count
        {
            var line = raw_input[i]
            if line != ""
            {
                if (i % num_question) == (num_question - 1)
                {
                    print(i)
                    var start_index = line.lastIndex(of: " ")
                    let end_index = line.range(of: "\ta")?.lowerBound
                    if (start_index != nil) && (end_index != nil)
                    {
                        start_index = line.index(line.lastIndex(of: " ")!, offsetBy: 1)
                        let correct_answer = line[start_index!..<end_index!]
                        line = line.replacingOccurrences(of: correct_answer, with: "____")
                        line = line.replacingOccurrences(of: "\ta", with: ("\t" + correct_answer))
                        let random_index = Int(arc4random_uniform(10))
                        line = line.replacingOccurrences(of: "\tb\tc\td", with: options_base[random_index])
                    }
                }
                result += line + "\n"
            }
        }
        
        print(result)
        return result;
    }
    
    //DEBUG USE FUNCTION
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
        //        let lyricsFileName = "Bohemian Rhapsody.lrc"
        //        let lyricsFileName = "Fly Me To The Moon.lrc"
//        let lyricsFileName = "My Heart Will Go On.lrc"
        let lyricsFileName = "Queen Bohemian Rhapsody.lrc"
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
            //            let output = parse_lyrics(input: fullText)
//                        print(output)
        }
        catch { print("DEBUG: Failed to read lyrics") }
        
    }
    
    
}
