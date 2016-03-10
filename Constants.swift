//
//  Constants.swift
//  waveStrike
//
//  Created by igmstudent on 3/10/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import SpriteKit

struct Constants{
    
    struct Font {
        static let MainFont = "Sailor-Beware"
        static let SecondaryFont = "Avenir-Medium"
        //static let FontColorWhite = ""
    }
    
    struct Image {
        static let PlayerImage = "ship_medium_body"
        static let ProjectileImage = "ship_gun_base"
        static let TargetImage1 = "ship_small_body"
        //static let TargetImage2 = ""
    }
    
    struct Scene {
        static let MainScreenBackgroundColor = UIColor(red: 76, green: 104, blue: 119)
        static let GameBackgroundColor = UIColor(red: 128, green: 158, blue: 169)
        static let WinBackgroundColor = UIColor(red: 99, green: 142, blue: 131)
        static let LoseBackgroundColor = UIColor(red: 54, green: 102, blue: 90)
    }
    
}