//
//  File:       GameViewController.swift
//  Purpose:    This file is the view controller for the game view where user can listen to the song and fill the blank in the lyrics
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


class GameViewController: UIViewController, AVAudioPlayerDelegate {
    
    //MARK: Variables
    
    var lyrics_text2:[String] = []  //Store the lyrics of the corresponding song
    var lyrics_timestamp2:[Float] = []  //Store the timestamp for every lyrics
    var options:[[String]] = [[],[],[],[]]  //Store the options for each questions
    var index_question2 = 0 //Index for the questions
    var isQuestion = false //Set true when question shows up
    var isShown = false //Set true when lyrics is shown
    var rightAnswerPlacement:UInt32 = 0 //Index of the correct answer
    var chanceAnswer = 3 //Number of chance allow to select the options
    var score = 0   //The score gained in the game
    var timer = Timer() //Set timer to run the lyrics
    
    var difficultLevel = 3
    
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var lyrics: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
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
        print("DEBUG: View Loaded")
        

        // Do any additional setup after loading the view.
        lyrics_text2 = []
        lyrics_timestamp2 = []
        options = [[],[],[],[]]
        isShown = false
        rightAnswerPlacement = 0
        
        if UserDefaults.standard.bool(forKey: "isDifficultModeOn") == true
        {
            difficultLevel = 1
        }
        
        score = 0
        isGameEnd = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
    }
    

    //Function: viewWillAppear(_ animated: Bool)
    //Description:   Before Game view appears, the lyrics should be loaded, and audio player should begin to play.
    //              The timer should start so that the lyrics can show up.
    override func viewWillAppear(_ animated: Bool)
    {
        lyrics_text2 = []
        lyrics_timestamp2 = []
        options = [[],[],[],[]]
        isShown = false
        rightAnswerPlacement = 0
        chanceAnswer = difficultLevel
        score = 0
        
        if isGameEnd == false
        {
            do
            {
                loadLyrics()
                
                //Run lyrics
                lyrics.text = ""
                option1.setTitle("", for: .normal)
                option2.setTitle("", for: .normal)
                option3.setTitle("", for: .normal)
                option4.setTitle("", for: .normal)
                
                //Disable the options button
                option1.isEnabled = false
                option2.isEnabled = false
                option3.isEnabled = false
                option4.isEnabled = false
                
                option1.backgroundColor = UIColor.lightGray
                option2.backgroundColor = UIColor.lightGray
                option3.backgroundColor = UIColor.lightGray
                option4.backgroundColor = UIColor.lightGray
                
                score = 0
                chanceAnswer = difficultLevel
                
//                //Run lyrics and options
//                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.showLyrics), userInfo: nil, repeats: true)
                
                //Play Song
//                let audioPath = Bundle.main.path(forResource: songs[index_currentSong], ofType: ".mp3")
                let audioPath = songsPath[index_currentSong]
                print(songs[index_currentSong])
                let audioURL = NSURL(string: audioPath)! as URL
                print(audioPath)
//                try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath) as URL)
                try audioPlayer = AVAudioPlayer(contentsOf: audioURL)
                audioPlayer.delegate = self
                songDuration = audioPlayer.duration
                songName.text = songs[index_currentSong]
                audioPlayer.volume = 1.0
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
                //Run lyrics and options
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.showLyrics), userInfo: nil, repeats: true)
                
            }
            catch
            {
                print ("ERROR: Game not started")
            }
        }
        super.viewWillAppear(animated)
        print("DEBUG: View Appear")

    }
    
    @objc func appDidEnterBackground() {
        // stop counter
        print("DEBUG: Enter background.")
        
        //Pause the song
        if audioPlayer.isPlaying == true
        {
            currentPlayingTime = audioPlayer.currentTime
            print ("DEBUG: Current time stampe: " + String(currentPlayingTime) + "/" + String(songDuration))
            audioPlayer.pause()
            //            timer.invalidate()
        }
        
        //Show popup window
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pauseSong") as! PausePopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    //Function: showLyrics()
    //Description:   Run the lyrics at every timestamps in the lyrics label
    @objc func showLyrics()
    {
        
        currentPlayingTime = audioPlayer.currentTime
        
        if index_question2 < lyrics_text2.count - 1
        {
            if Float(currentPlayingTime) >= lyrics_timestamp2[index_question2] && Float(currentPlayingTime) <= lyrics_timestamp2[index_question2+1]
            {
                if Float(currentPlayingTime) >= lyrics_timestamp2[index_question2+1] - 1
                {
                    index_question2 += 1
                    isShown = false
                }
                if isShown == false
                {
                    lyrics.text = lyrics_text2[index_question2]
                    
                    if lyrics_text2[index_question2].contains("____")
                    {
                        isQuestion = true
                        chanceAnswer = difficultLevel
                        print("DEBGU: Question")
                    }
                    else
                    {
                        isQuestion = false
                    }
                    if(isQuestion == true)
                    {
                        var option_btn:UIButton = UIButton()
                        rightAnswerPlacement = arc4random_uniform(4) + 1
                        var wrongAnswerPlacement = 1
                        
                        for i in 1...4
                        {
                            option_btn = view.viewWithTag(i) as! UIButton
                            print("btn" + String(i))
                            option_btn.isEnabled = true
                            option_btn.backgroundColor = UIColor.cyan
                            if i == Int(rightAnswerPlacement)
                            {
                                option_btn.setTitle(options[0][index_question2], for: .normal)
                            }
                            else
                            {
                                option_btn.setTitle(options[wrongAnswerPlacement][index_question2], for: .normal)
                                wrongAnswerPlacement += 1
                            }
                        }
                    }
                    else
                    {
                        var option_btn:UIButton = UIButton()
                        for i in 1...4
                        {
                            option_btn = view.viewWithTag(i) as! UIButton
                            option_btn.isEnabled = false
                            option_btn.setTitle("", for: .normal)
                            option_btn.backgroundColor = UIColor.lightGray
                        }
                    }
                    isShown = true
                    print("DEBGU: Lyrics loaded: " + String(currentPlayingTime) + " | " + String(lyrics_timestamp2[index_question2]))
                }
            }
        }
        else
        {
            index_question2 = 0
        }

    }
    
    
    //Function: loadLyrics()
    //Description:  Load the lyrics from the local library to the lyrics_text2
    func loadLyrics()
    {
        print("DEBUG: Loading Lyrics...")
        let lrcPath = Bundle.main.path(forResource: songs[index_currentSong], ofType: ".lrc")
        let filemgr = FileManager.default
        
        if lrcPath == nil
        {
            print("DEBUG: this song does not have the lyrics")
            return
        }
        
        if filemgr.fileExists(atPath: lrcPath!)
        {
            do
            {
                let fullText = try String(contentsOfFile: lrcPath!, encoding: .utf8)
                let readings = fullText.components(separatedBy: "\n")
                
                for i in 0..<readings.count
                {
                    let row = readings[i].components(separatedBy: "\t")
                    


                    lyrics_timestamp2.append(Float(row[0])!)
                    lyrics_text2.append(row[1])
                    options[0].append(row[2])
                    options[1].append(row[3])
                    options[2].append(row[4])
                    options[3].append(row[5])
                    
                }
                index_question2 = 0
                isShown = false
                isQuestion = false
                
            }
            catch
            {
                print("ERROR: cannot load lyrics")
            }
        }
        else
        {
            print("ERROR: .lrc file not found")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function: prepare(for segue: UIStoryboardSegue, sender: Any?)
    //Description:  Pass score to the end VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let endGameVC = segue.destination as! EndPopupViewController
        endGameVC.score = score
    }
 
    //Function: audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    //Description: Define the event when song done
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("DEBUG: Song Done")
        audioPlayer.stop()
        timer.invalidate()
        
        performSegue(withIdentifier: "endGame", sender: self)
        
    }
    
    //MARK: Buttons
    //Function: pauseSong(_ sender: UIButton)
    //Description: When the pause button is pressed, the Pause popup view should show up
    @IBAction func pauseSong(_ sender: UIButton) {
        //Pause the song
        if audioPlayer.isPlaying == true
        {
            currentPlayingTime = audioPlayer.currentTime
            print ("DEBUG: Current time stampe: " + String(currentPlayingTime) + "/" + String(songDuration))
            audioPlayer.pause()
            //            timer.invalidate()
        }
        
        //Show popup window
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pauseSong") as! PausePopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    

    //Function: chooseAnswer(_ sender: UIButton)
    //Description: When the button is pressed, the player chose the answer to the question
    @IBAction func chooseAnswer(_ sender: UIButton) {
        if sender.tag == Int(rightAnswerPlacement)
        {
            print("DEBUG: Correct")
            isQuestion = false
            
            if difficultLevel == 1
            {
                score = score + chanceAnswer + 3
            }
            else
            {
                score = score + chanceAnswer
            }
            
            
            option1.isEnabled = false
            option2.isEnabled = false
            option3.isEnabled = false
            option4.isEnabled = false
            
            option1.backgroundColor = UIColor.lightGray
            option2.backgroundColor = UIColor.lightGray
            option3.backgroundColor = UIColor.lightGray
            option4.backgroundColor = UIColor.lightGray
            sender.backgroundColor = UIColor.green
            chanceAnswer = difficultLevel
        }
        else
        {
            print("DEBUG: Wrong")
            chanceAnswer -= 1
            if chanceAnswer == 0
            {
                option1.isEnabled = false
                option2.isEnabled = false
                option3.isEnabled = false
                option4.isEnabled = false
                
                option1.backgroundColor = UIColor.lightGray
                option2.backgroundColor = UIColor.lightGray
                option3.backgroundColor = UIColor.lightGray
                option4.backgroundColor = UIColor.lightGray
                chanceAnswer = difficultLevel
            }
            else
            {
                sender.isEnabled = false
                sender.backgroundColor = UIColor.lightGray
            }

        }
    }
    
    //MARK: Exit
    //Function: unwindToGameViewController(unwindSegue: UIStoryboardSegue)
    //Description:  This funcion can be called by any view that will return to the Game view
    @IBAction func unwindToGameViewController(unwindSegue: UIStoryboardSegue){}
    


}
