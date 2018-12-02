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
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var Play: UIButton!
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var Exit: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
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
    
//    override func viewWillTransition(to size:CGSize, with coordinator: UIViewControllerTransitionCoordinator){
//        super.viewWillTransition(to: size, with: coordinator)
//        DispatchQueue.main.async {
//            self.logo.frame = CGRect(x: 20 * UIScreen.main.bounds.width/100, y: 5 * UIScreen.main.bounds.height/100, width: 40 * UIScreen.main.bounds.width/100, height: 90 * UIScreen.main.bounds.height/100)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if UIFont(name: Theme.mainFontName, size: 42) != nil {
            Play.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 52)
        }
        if UIFont(name: Theme.mainFontName, size: 42) != nil {
            Settings.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 32)
        }
        if UIFont(name: Theme.mainFontName, size: 42) != nil {
            Exit.titleLabel?.font = UIFont(name: Theme.mainFontName, size: 32)
        }
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        bg.image = UIImage(named: Theme.mainBackground)!
        bg.contentMode = UIViewContentMode.scaleAspectFill
        bg.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bg.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.sendSubview(toBack: bg)
        
        Play.setBackgroundImage(UIImage(named: Theme.bigButton), for: UIControlState.normal)
        Settings.setBackgroundImage(UIImage(named: Theme.smallButton), for: UIControlState.normal)
        Exit.setBackgroundImage(UIImage(named: Theme.smallButton), for: UIControlState.normal)
        
        Play.titleLabel?.textColor = Theme.mainFontColor
        Settings.titleLabel?.textColor = Theme.mainFontColor
        Exit.titleLabel?.textColor = Theme.mainFontColor
        
//        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        logo.image = UIImage(named: Theme.logo)!
        logo.contentMode = UIViewContentMode.scaleAspectFit
//        logo.frame = CGRect(x: 20 * UIScreen.main.bounds.width/100, y: 5 * UIScreen.main.bounds.height/100, width: 40 * UIScreen.main.bounds.width/100, height: 90 * UIScreen.main.bounds.height/100)
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
