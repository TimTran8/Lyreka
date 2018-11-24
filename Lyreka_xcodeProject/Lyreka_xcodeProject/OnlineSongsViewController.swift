//
//  OnlineSongsViewController.swift
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 11/18/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit

struct SongFile: Decodable
{
    let filename: String
    
}

var song = [SongFile]()




//{"_id":"5bf0b5a46d5f610004290b50","length":5998687,"chunkSize":261120,"uploadDate":"2018-11-18T00:43:21.086Z","filename":"Avicii - Wake Me Up.mp3","md5":"92e526af198a0fa9d55d51a4554f6834","contentType":"audio/mp3"}]

class OnlineSongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var songList:[String] = ["123","234","456"]
    


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
        
        var song_to_download = cell.textLabel!.text! as String
        print("DEBUG: Prepare to download" + song_to_download)
        song_to_download = song_to_download.replacingOccurrences(of: " ", with: "%20")
        let download_url = "https://lyreka.herokuapp.com/files/" + song_to_download
        print("DEBUG: Getting song from:" + download_url)
    }
    
    
    
    func getSongName()
    {
        print("DEBUG: Loading JSON")
//        let url = URL(string: "http://lyreka.herokuapp.com/files")
        guard let url = URL(string: "http://lyreka.herokuapp.com/files") else{return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let err = error
                {
                    print("ERROR: Failed to get data from url:", err)
                    return
                }
                

//            guard let dataResponse = data,
//                error == nil else {print("ERROR: cannot load data")
//                return}
            guard let data = data else{return}
            
            do
            {
                let decoder = JSONDecoder()
                song = try decoder.decode([SongFile].self, from: data)
                self.myTableView2.reloadData()
//                for songName in self.song
//                {
////                    print(songName.filename)
//                    self.songList.append(songName.filename)
//
////                    self.myTableView
//                }
                
                for i in song
                {
                    print(i.filename)
                }
                
            }
            catch{print("ERROR:cannot decode")}
            
            
//            OperationQueue.main.addOperation {
//                self.myTableView.reloadData()
//            }

            
//            do
//            {
//                let myJson = try JSONSerialization.jsonObject(with: dataResponse, options: JSONSerialization.ReadingOptions.mutableContainers)
//                print(myJson)
//
//            }
//            catch{ print("ERROR: cannot read JSON")}
            

            }
        }
        
        
        task.resume()
//        tmp_str = myJson
        for i in song
        {
            print(i.filename)
        }
        
//                        for i in songList
//                        {
//                            print(i)
//                        }
        
    }
    
    

    
   
    
    
}
