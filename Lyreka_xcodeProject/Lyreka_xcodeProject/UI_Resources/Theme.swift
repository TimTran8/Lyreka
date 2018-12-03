//
//  Theme_Antique.swift
//  Lyreka_xcodeProject
//
//  Created by amh12 on 2018-11-28.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    static var select = 0
    
    static let numberThemes = 2
    static var titleFontName = "SmokeInTheWoods"
    static var mainFontName = "SmokeInTheWoods"
    static var bigButton = "wood_big_button"
    static var smallButton = "wood_small_button"
    static var smallButtonGray = "wood_small_button_gray"
    static var smallButtonGreen = "wood_small_button_green"
    static var mainBackground = "wood_bg_walnut"
    static var logo = "wood_burnt_logo"
    static var titleFontColor = UIColor.black
    static var mainFontColor = UIColor.black
    static var tableTop = "wood_walnut_bar"
    static var cellBackground = "wood_light_bar"
    static var cellBackgroundGreen = "wood_light_bar_green"
    static var lyricBg = "wood_lyric_bg"
    
    static func rotateTheme(){
        Theme.select = Theme.select + 1
        if Theme.select % Theme.numberThemes == 0 {
            print("wood theme")
            Theme.titleFontName = "SmokeInTheWoods"
            Theme.mainFontName = "SmokeInTheWoods"
            Theme.bigButton = "wood_big_button"
            Theme.smallButton = "wood_small_button"
            Theme.smallButtonGray = "wood_small_button_gray"
            Theme.smallButtonGreen = "wood_small_button_green"
            Theme.mainBackground = "wood_bg_walnut"
            Theme.logo = "wood_burnt_logo"
            Theme.titleFontColor = UIColor.black
            Theme.mainFontColor = UIColor.black
            Theme.tableTop = "wood_walnut_bar"
            Theme.cellBackground = "wood_light_bar"
            Theme.cellBackgroundGreen = "wood_light_bar_green"
            Theme.lyricBg = "wood_lyric_bg"
        }
        else {
            print("fabric theme")
            Theme.titleFontName = "DJBHandStitchedAlpha" //
            Theme.mainFontName = "MixStitch" //
            Theme.bigButton = "fabric_big_button" //
            Theme.smallButton = "fabric_small_button"
            Theme.smallButtonGray = "fabric_small_button_gray"
            Theme.smallButtonGreen = "fabric_small_button_green"
            Theme.mainBackground = "fabric_bg"
            Theme.logo = "fabric_double_stitched_logo"
            Theme.titleFontColor = UIColor(red: (243/255.0), green: (236/255.0), blue: (196/255.0), alpha: 1.0)
            Theme.mainFontColor = UIColor(red: (243/255.0), green: (236/255.0), blue: (196/255.0), alpha: 1.0)
            Theme.tableTop = "fabric_walnut_bar"
            Theme.cellBackground = "fabric_light_bar"
            Theme.cellBackgroundGreen = "fabric_light_bar_green"
            Theme.lyricBg = "fabric_lyric_bg"
        }
    }
}
