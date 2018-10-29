//
//  EndPopupViewController.swift
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 10/28/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit
import AVFoundation

class EndPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playNext(_ sender: UIButton) {
        if index_currentSong < songs.count
        {
            index_currentSong += 1
        }

        performSegue(withIdentifier: "backToGame", sender: self)
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
//        audioPlayer.play()
        performSegue(withIdentifier: "backToGame", sender: self)
    }
    
    
    @IBAction func toPlaylist(_ sender: UIButton) {
        isGameEnd = true
        performSegue(withIdentifier: "endToPlaylist", sender: self)
        
    }
    
    
    @IBAction func toMainMenu(_ sender: UIButton) {
        isGameEnd = true
        performSegue(withIdentifier: "endToMain", sender: self)
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
