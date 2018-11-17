//  File:       OptionViewController.swift
//  Purpose:    This file is the view controller for the option menu which contains the buttons for customizing the app setting
//  Project:    Lyreka_xcodeProject
//  Group:      Lyreka CMPT275-FALL18-Group08
//  For the contributors, changes, and bugs of this file, please refer to https://github.com/TimTran8/CMPT275Group8
//
//
//  Created by Li heng Ou on 10/26/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {
    
    //MARK: Variables

    @IBOutlet var themeButton: [UIButton]!
    @IBOutlet weak var enableDifficultMode: UISwitch!
    
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
    
    //MARK: Buttons
    
    @IBAction func selectTheme(_ sender: UIButton) {

        themeButton.forEach{ (button) in
            button.isHidden = !button.isHidden
        }
    
    }

    
    @IBAction func changeTheme(_ sender: UIButton) {
        themeButton.forEach{ (button) in
            button.isHidden = true
        }
    }
    //Function: showPopup
    //Input: UIButton
    //Desription: When button is pressed, the PopupViewController should show up
    @IBAction func showPopup(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup_NotImplemented") as! PopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    
    @IBAction func enableDifficultMode(_ sender: UISwitch) {
        if sender.isOn
        {
            print("DEBUG: Difficult mode is on")
            UserDefaults.standard.set(true, forKey: "isDifficultModeOn")
        }
        else
        {
            print("DEBUG: Difficult mode is off")
            UserDefaults.standard.set(false, forKey: "isDifficultModeOn")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableDifficultMode.setOn(UserDefaults.standard.bool(forKey: "isDifficultModeOn"), animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


    

}
