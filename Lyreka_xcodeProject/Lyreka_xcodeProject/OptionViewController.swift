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
import CoreLocation

class OptionViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Variables
    let lcManager = CLLocationManager()
    
    @IBOutlet var themeButton: [UIButton]!
    @IBOutlet weak var enableDifficultMode: UISwitch!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var enableDifficultImage: UIView!
    @IBOutlet weak var enableDifficultLabel: UILabel!
    @IBOutlet weak var onlineSongLibrary: UIButton!
    @IBOutlet weak var selectTheme: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var shareLocation: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var center_toggle_image: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableDifficultMode.setOn(UserDefaults.standard.bool(forKey: "isDifficultModeOn"), animated: false)
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        bg.image = UIImage(named: Theme.mainBackground)!
        bg.contentMode = UIViewContentMode.scaleAspectFill
        bg.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bg.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.sendSubview(toBack: bg)
        
        settingsLabel.font = UIFont(name: Theme.titleFontName, size: 62)
        settingsLabel.textAlignment = .center
        enableDifficultLabel.font = UIFont(name: Theme.titleFontName, size: 22)
        
        center_toggle_image.image = UIImage(named: Theme.bigButton)
        back.setBackgroundImage(UIImage(named: Theme.smallButton), for: UIControlState.normal)
        onlineSongLibrary.setBackgroundImage(UIImage(named: Theme.smallButton), for: UIControlState.normal)
        selectTheme.setBackgroundImage(UIImage(named: Theme.smallButton), for: UIControlState.normal)
        signIn.setBackgroundImage(UIImage(named: Theme.smallButton), for: UIControlState.normal)
        shareLocation.setBackgroundImage(UIImage(named: Theme.smallButton), for: UIControlState.normal)
        if UIFont(name: Theme.mainFontName, size: 22) != nil {
            back.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 22)
        }
        if UIFont(name: Theme.mainFontName, size: 22) != nil {
            onlineSongLibrary.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 22)
        }
        if UIFont(name: Theme.mainFontName, size: 22) != nil {
            selectTheme.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 22)
        }
        if UIFont(name: Theme.mainFontName, size: 22) != nil {
            signIn.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 22)
        }
        if UIFont(name: Theme.mainFontName, size: 22) != nil {
            shareLocation.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 22)
        }
        back.titleLabel?.textColor = Theme.mainFontColor
        onlineSongLibrary.titleLabel?.textColor = Theme.mainFontColor
        selectTheme.titleLabel?.textColor = Theme.mainFontColor
        signIn.titleLabel?.textColor = Theme.mainFontColor
        shareLocation.titleLabel?.textColor = Theme.mainFontColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Buttons
    
    
    //Function: selectTheme
    //Desription: When select theme button is pressed, the theme options should show up
    @IBAction func selectTheme(_ sender: UIButton) {

        themeButton.forEach{ (button) in
            button.isHidden = !button.isHidden
        }
    
    }

    //Function: changeTheme
    //Desription: When theme is selected, the app theme should change (Will implement in version 3)
    @IBAction func changeTheme(_ sender: UIButton) {
        themeButton.forEach{ (button) in
            button.isHidden = true
        }
    }
    
    //Function: showPopup
    //Input: UIButton
    //Desription: When button is pressed, the PopupViewController should show up
    @IBAction func showPopup(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "email") != nil
        {
            sender.setTitleColor(UIColor.lightGray, for: .normal)
            sender.isEnabled = false
            return
        }
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup_NotImplemented") as! PopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    
    //Function: enableDifficultMode
    //Desription: enable/disable the diffcult mode
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
    
    
    
    @IBAction func shareLocation(_ sender: UIButton) {
        lcManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            lcManager.delegate = self
            lcManager.desiredAccuracy = kCLLocationAccuracyBest
//            lcManager.requestLocation()
            lcManager.startUpdatingLocation()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print(location.coordinate)
    }
    
    //Function: browserSongDatabase
    //Desription: When button is clicked, the user can browser the online database to download a song.
    @IBAction func browserSongDatabase(_ sender: UIButton) {
        
    }
    
    


    @IBAction func unwindToOptionViewController(unwindSegue: UIStoryboardSegue){}

}
