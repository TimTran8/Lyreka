//
//  GameViewController.swift
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 10/28/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit
import AVFoundation

var index_question = 0
var timer = Timer()
var lyrics_text = ["Fly me to the moon", "Let me play among the stars", "Let me see what spring is like"]
var lyrics_timestamp = [10, 17, 25]

class GameViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var lyrics: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        // Do any additional setup after loading the view.

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Appear")
        
        if isGameEnd == false
        {
            do
            {
                //Run lyrics
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.action), userInfo: nil, repeats: true)
                
                //Play Song
                let audioPath = Bundle.main.path(forResource: songs[index_currentSong], ofType: ".mp3")
                try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
                audioPlayer.delegate = self
                songDuration = audioPlayer.duration
                songName.text = songs[index_currentSong]
                audioPlayer.play()
                
            }
            catch
            {
                print ("ERROR: Game not started")
            }
        }
        

    }
    
    @objc func action()
    {
        
        currentPlayingTime = audioPlayer.currentTime
        
        if Int(currentPlayingTime) >= lyrics_timestamp[index_question] && Int(currentPlayingTime) <= lyrics_timestamp[index_question] + 5
        {
            lyrics.text = lyrics_text[index_question]
            if Int(currentPlayingTime) >= lyrics_timestamp[index_question] + 4
            {
                index_question += 1
            }
            
        }
        else
        {
            lyrics.text = ""
        }
        if index_question >= lyrics_text.count
        {
            index_question = 0
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Event when song done
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("Song Done Game")
        audioPlayer.stop()
        
        //Show popup window
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndPopupViewController
//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        performSegue(withIdentifier: "endGame", sender: self)
        
    }
    
    //MARK: Button
    @IBAction func pauseSong(_ sender: UIButton) {
        //Pause the song
        if audioPlayer.isPlaying == true
        {
            currentPlayingTime = audioPlayer.currentTime
            print ("Current time stampe: " + String(currentPlayingTime) + "/" + String(songDuration))
            audioPlayer.pause()
        }
        
        //Show popup window
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pauseSong") as! PausePopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    //MARK: back to game
    @IBAction func unwindToGameViewController(unwindSegue: UIStoryboardSegue){}
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
