//
//  File:       MainViewController.swift
//  Purpose:    This file is the view controller for the main menu which is the first view of the app when the app runs.
//  Project:    Lyreka_xcodeProject
//  Group:      Lyreka CMPT275-FALL18-Group08
//  For the contributors, changes, and bugs of this file, please refer to https://github.com/TimTran8/CMPT275Group8
//  Created by Li heng Ou on 10/26/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: Variables
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var Play: UIButton!
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var Exit: UIButton!
    
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

    
    //MARK: Functions
    
    override func awakeFromNib() {
        //print(Theme.titleFontName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if UIFont(name: Theme.titleFontName, size: 80) != nil {
            mainTitle.font = UIFont(name: Theme.titleFontName, size: 80)
        }
        else{print("--- font error ---")
            for name in UIFont.familyNames
            {
                print(name)
            }
        }
        if UIFont(name: Theme.mainFontName, size: 42) != nil {
            Play.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 42)
        }
        if UIFont(name: Theme.mainFontName, size: 42) != nil {
            Settings.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 32)
        }
        if UIFont(name: Theme.mainFontName, size: 42) != nil {
            Exit.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 32)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Function: unwindToMainViewController
    //Input: UIStoryboardSegue
    //Desription: This is the unwinf function for any view using segue so that the view can go back to the main view directly.
    @IBAction func unwindToMainViewController(unwindSegue: UIStoryboardSegue){}
    
    
    
    //Function: exitApp
    //Input: UIButton
    //Desription: When button is pressed, the app should stop running and closed.
    @IBAction func exitApp(_ sender: UIButton) {
        exit(0)
    }


}
