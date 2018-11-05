//
//
//  File:       PopupViewController.swift
//  Purpose:    This file is the view controller for the popup window where user can toggle some setting buttons
//  Project:    Lyreka_xcodeProject
//  Group:      Lyreka CMPT275-FALL18-Group08
//  For the contributors, changes, and bugs of this file, please refer to https://github.com/TimTran8/CMPT275Group8
//
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 10/26/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    //MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set background color to light grey
        self.view.backgroundColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    //MARK: Functions
    
    //MARK: Buttons
    
    //Function: closePopup(_ sender: UIButton)
    //Input:    sender: UIButton
    //Description:  When the button is pressed, it should close this Popup view
    @IBAction func closePopup(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    

}
