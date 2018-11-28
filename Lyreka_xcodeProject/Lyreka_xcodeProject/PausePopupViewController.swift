//
//  File:       PausePopupViewController.swift
//  Purpose:    This view controller will show up when the user pause the song so that the user can go back to the playlist or resume the song
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

class PausePopupViewController: UIViewController {


    
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
        
        //Set background color to light grey
        self.view.backgroundColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 0.8)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Buttons

    //Function: resumeSong(_ sender: UIButton)
    //Description:  When the button is pressed, it should resume the song and go back to the Game view
    @IBAction func resumeSong(_ sender: UIButton) {
        //resume the song
        if audioPlayer.isPlaying == false
        {
            audioPlayer.play()
        }
        
        //remove the popup window
        self.view.removeFromSuperview()
    }
    
    //Function: back2playlist(_ sender: UIButton)
    //Description:  When the button is pressed, it should stop the song and go back to the Playlist view
    @IBAction func back2playlist(_ sender: UIButton) {
        audioPlayer.stop()
        performSegue(withIdentifier: "backToPlaylist", sender: self)
    }
    

}
