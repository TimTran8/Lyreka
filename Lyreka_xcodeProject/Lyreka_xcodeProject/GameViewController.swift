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
    
    var lyrics_text2:[String] = []
    var lyrics_timestamp2:[Float] = []
    var options:[[String]] = [[],[],[],[]]
    var index_question2 = 0
    var isQuestion = false
    var isShown = false
    var rightAnswerPlacement:UInt32 = 0
    var chanceAnswer = 3
    var score = 0
    
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var lyrics: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        // Do any additional setup after loading the view.

        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Appear")
        
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
                
                score = 0
                chanceAnswer = 3
                
                //Run lyrics and options
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.showLyrics), userInfo: nil, repeats: true)
                
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
    
    @objc func showLyrics()
    {
        
        currentPlayingTime = audioPlayer.currentTime
        
//        if Int(currentPlayingTime) >= lyrics_timestamp[index_question] && Int(currentPlayingTime) <= lyrics_timestamp[index_question] + 5
//        {
//            lyrics.text = lyrics_text[index_question]
//            if Int(currentPlayingTime) >= lyrics_timestamp[index_question] + 4
//            {
//                index_question += 1
//            }
//
//        }
//        else
//        {
//            lyrics.text = ""
//        }
//        if index_question >= lyrics_text.count
//        {
//            index_question = 0
//        }
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
                        chanceAnswer = 3
                        print("Question")
                    }
                    else
                    {
                        isQuestion = false
                    }
                    
//                    option1.setTitle(options[0][index_question2], for: .normal)
//                    option2.setTitle(options[1][index_question2], for: .normal)
//                    option3.setTitle(options[2][index_question2], for: .normal)
//                    option4.setTitle(options[3][index_question2], for: .normal)
                    
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
                    print("Lyrics loaded: " + String(currentPlayingTime) + " | " + String(lyrics_timestamp2[index_question2]))
                }

            }
//            else
//            {
//                lyrics.text = ""
//            }
        }
        else
        {
            index_question2 = 0
        }

    }
    
    func loadLyrics()
    {
//        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        let lrcPath = Bundle.main.path(forResource: songs[index_currentSong], ofType: ".lrc")
        let filemgr = FileManager.default
        
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
    
    //MARK: Pass score to the end VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var endGameVC = segue.destination as! EndPopupViewController
        endGameVC.score = score
    }
    
    //Event when song done
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("Song Done Game")
        audioPlayer.stop()
        timer.invalidate()
        
        //Show popup window
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndPopupViewController
//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        performSegue(withIdentifier: "endGame", sender: self)
        
    }
    
    //MARK: Button
//    @IBAction func pauseSong(_ sender: UIButton) {
//        //Pause the song
//        if audioPlayer.isPlaying == true
//        {
//            currentPlayingTime = audioPlayer.currentTime
//            print ("Current time stampe: " + String(currentPlayingTime) + "/" + String(songDuration))
//            audioPlayer.pause()
////            timer.invalidate()
//        }
//
//        //Show popup window
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pauseSong") as! PausePopupViewController
//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
//
//    }
    
    @IBAction func pauseSong(_ sender: UIButton) {
        //Pause the song
        if audioPlayer.isPlaying == true
        {
            currentPlayingTime = audioPlayer.currentTime
            print ("Current time stampe: " + String(currentPlayingTime) + "/" + String(songDuration))
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
    
    
    @IBAction func chooseAnswer(_ sender: UIButton) {
        if sender.tag == Int(rightAnswerPlacement)
        {
            print("Correct")
            isQuestion = false
            
            score = score + chanceAnswer
            
            option1.isEnabled = false
            option2.isEnabled = false
            option3.isEnabled = false
            option4.isEnabled = false
            
            option1.backgroundColor = UIColor.lightGray
            option2.backgroundColor = UIColor.lightGray
            option3.backgroundColor = UIColor.lightGray
            option4.backgroundColor = UIColor.lightGray
            sender.backgroundColor = UIColor.green
            chanceAnswer = 3
        }
        else
        {
            print("Wrong")
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
                chanceAnswer = 3
            }
            else
            {
                sender.isEnabled = false
                sender.backgroundColor = UIColor.lightGray
            }

        }
    }
    
    //MARK: back to game
    @IBAction func unwindToGameViewController(unwindSegue: UIStoryboardSegue){}
    

    
    /*
    // MARK: - Navigatio/Users/lihengo/Desktop/Yesterday Once More.lrcn

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
