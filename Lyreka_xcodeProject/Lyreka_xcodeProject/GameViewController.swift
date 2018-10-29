//
//  GameViewController.swift
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 10/28/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var songName: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do
        {
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
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndPopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
