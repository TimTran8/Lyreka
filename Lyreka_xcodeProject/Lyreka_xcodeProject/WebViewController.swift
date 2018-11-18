//
//  WebViewController.swift
//  Lyreka_xcodeProject
//
//  Created by Li heng Ou on 11/17/18.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://lyreka.herokuapp.com/")
        myWebView.loadRequest(URLRequest(url: url!))
        myWebView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let text = webView.request?.url?.absoluteString{
            print(text)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
