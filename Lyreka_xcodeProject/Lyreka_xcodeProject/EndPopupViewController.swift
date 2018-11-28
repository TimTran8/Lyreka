//
//  File:       EndPopupViewController.swift
//  Purpose:    This view controller will show the view when the song is done, and the user can back to the playlist or main menu, or the user can play the next/same song
//  Project:    Lyreka_xcodeProject
//  Group:      Lyreka CMPT275-FALL18-Group08
//  For the contributors, changes, and bugs of this file, please refer to https://github.com/TimTran8/CMPT275Group8
//  
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 10/28/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit
import AVFoundation

class EndPopupViewController: UIViewController {
    
    //MARK: Variables
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var signinReminder: UILabel!
    var score = 0

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Show the song name
        songName.text = songs[index_currentSong]
        //Get and change score
        self.view.backgroundColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 0.8)
        scoreLabel.text = "   Score: " + String(score)
        
        if UserDefaults.standard.string(forKey: "email") != nil
        {
            signinReminder.text = ""
            let email = UserDefaults.standard.string(forKey: "email")! as String
            print(email)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.string(from: Date())
            print(date)
            
            
            let url = URL(string: "http://lyreka.herokuapp.com/updateScore")!;
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            let putString = "email=\(email)&date=\(date)&score=\(score)"
            print(putString)
            request.httpBody = putString.data(using: .utf8)
        
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in}
            task.resume()
        }
        
        
//        if highScores[index_currentSong] < score
//        {
//            highScores[index_currentSong] = score
//            playlistSync()
//        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Buttons
    //Function: playNext(_ sender: UIButton)
    //Description:  When the button is pressed, it should run the next song and go back to the Game view
    @IBAction func playNext(_ sender: UIButton) {
        if index_currentSong < songs.count - 1
        {
            index_currentSong += 1
            performSegue(withIdentifier: "backToGame", sender: self)
        }

    }
    
    //Function: playAgain(_ sender: UIButton)
    //Description:  When the button is pressed, it should run the song again and go back to the Game view
    @IBAction func playAgain(_ sender: UIButton) {
//        audioPlayer.play()
        performSegue(withIdentifier: "backToGame", sender: self)
    }
    
    //Function: toPlaylist(_ sender: UIButton)
    //Description:  When the button is pressed, it should go back to the Playlist view
    @IBAction func toPlaylist(_ sender: UIButton) {
        isGameEnd = true
        performSegue(withIdentifier: "endToPlaylist", sender: self)
        
    }
    
    //Function: toMainMenu(_ sender: UIButton)
    //Description:  When the button is pressed, it should go back to the Main view
    @IBAction func toMainMenu(_ sender: UIButton) {
        isGameEnd = true
        performSegue(withIdentifier: "endToMain", sender: self)
    }

}
