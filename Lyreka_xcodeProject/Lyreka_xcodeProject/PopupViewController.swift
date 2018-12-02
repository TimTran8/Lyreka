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
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
        if userEmail.text != "" && firstName.text != "" && lastName.text != ""
        {
            UserDefaults.standard.set(userEmail.text, forKey: "email")
            let email = UserDefaults.standard.string(forKey: "email")! as String
            let userlastName = lastName.text! as String
            let userfistName = firstName.text! as String
            let url = URL(string: "http://lyreka.herokuapp.com/userID")!;
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            let putString = "firstName=\(userfistName)&lastName=\(userlastName)&email=\(email)"
            print(putString)
            request.httpBody = putString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in}
            task.resume()
            
            self.view.removeFromSuperview()
        }
        
        
    }
    
    

    @IBAction func back2Option(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
}
