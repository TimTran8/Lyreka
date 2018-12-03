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
    
    @IBOutlet var view1: UIView!
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
        
        settingsLabel.font = UIFont(name: Theme.titleFontName, size: 42)
        settingsLabel.textAlignment = .center
        settingsLabel.textColor = Theme.titleFontColor
        
        enableDifficultLabel.font = UIFont(name: Theme.mainFontName, size: 22)
        enableDifficultLabel.textColor = Theme.mainFontColor
        
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
        back.setTitleColor(Theme.mainFontColor, for: UIControlState.normal)
        onlineSongLibrary.setTitleColor(Theme.mainFontColor, for: UIControlState.normal)
        selectTheme.setTitleColor(Theme.mainFontColor, for: UIControlState.normal)
        signIn.setTitleColor(Theme.mainFontColor, for: UIControlState.normal)
        shareLocation.setTitleColor(Theme.mainFontColor, for: UIControlState.normal)
        
        onlineSongLibrary.titleLabel?.textAlignment = NSTextAlignment.center
        selectTheme.titleLabel?.textAlignment = NSTextAlignment.center
        signIn.titleLabel?.textAlignment = NSTextAlignment.center
        shareLocation.titleLabel?.textAlignment = NSTextAlignment.center
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
//        themeButton.forEach{ (button) in
//            button.isHidden = true
//        }
        
        Theme.rotateTheme()
        self.viewDidLoad()
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
            guard let locValue: CLLocationCoordinate2D = lcManager.location?.coordinate else {return}
            getAddressFromLatLon(pdblLatitude: locValue.latitude.description, withLongitude: locValue.longitude.description)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        getAddressFromLatLon(pdblLatitude: locValue.latitude.description, withLongitude: locValue.longitude.description)
//        let location = locations[0]
//        print("test \(location.coordinate)")
    }
    
    var documentInteractionController : UIDocumentInteractionController = UIDocumentInteractionController()
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + " "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + " "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + " "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + " "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode!
                    }
                    print(addressString)
                    
                    let urlString = addressString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let url = URL(string: "whatsapp://send?text=\(urlString!)")
                    if UIApplication.shared.canOpenURL(url! as URL)
                    {
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    }
                }
        })
    }
    

    //Function: browserSongDatabase
    //Desription: When button is clicked, the user can browser the online database to download a song.
    @IBAction func browserSongDatabase(_ sender: UIButton) {
        
    }
    
    


    @IBAction func unwindToOptionViewController(unwindSegue: UIStoryboardSegue){}

}
