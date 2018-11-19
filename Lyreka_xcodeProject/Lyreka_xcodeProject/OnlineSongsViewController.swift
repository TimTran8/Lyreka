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




//{"_id":"5bf0b5a46d5f610004290b50","length":5998687,"chunkSize":261120,"uploadDate":"2018-11-18T00:43:21.086Z","filename":"Avicii - Wake Me Up.mp3","md5":"92e526af198a0fa9d55d51a4554f6834","contentType":"audio/mp3"}]

class OnlineSongsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    var song:[SongFile] = []
    var songList:[String] = []
    

    @IBOutlet weak var myTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: OnlineSongsView loaded")
        
        self.getSongName()
        
        // Do any additional setup after loading the view.
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
        return songList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_online", for: indexPath)
        cell.textLabel?.text = songList[indexPath.row]
        return cell
    }

    func getSongName()
    {
        print("DEBUG: Loading JSON")
//        let url = URL(string: "http://lyreka.herokuapp.com/files")
        guard let url = URL(string: "http://lyreka.herokuapp.com/files") else{return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let dataResponse = data,
//                error == nil else {print("ERROR: cannot load data")
//                return}
            
            do
            {
                self.song = try JSONDecoder().decode([SongFile].self, from: data!)

                for songName in self.song
                {
//                    print(songName.filename)
                    self.songList.append(songName.filename)
                    
//                    self.myTableView
                }
                

                
            }
            catch{print("ERROR:cannot decode")}
            
            
            OperationQueue.main.addOperation {
                self.myTableView.reloadData()
            }

            
//            do
//            {
//                let myJson = try JSONSerialization.jsonObject(with: dataResponse, options: JSONSerialization.ReadingOptions.mutableContainers)
//                print(myJson)
//
//            }
//            catch{ print("ERROR: cannot read JSON")}
            


        }
        
        
        task.resume()
//        tmp_str = myJson
        
        
//                        for i in songList
//                        {
//                            print(i)
//                        }
        
    }
    
    
    func getSongName2()
    {
//        let url = URL(string: "http://lyreka.herokuapp.com/files")
//        let jsonData = NSData(contentsOf: url!)
//        
//        let jsonObject = JSON(data: jsonData)
        
        
    }
    
   
    
    
}
