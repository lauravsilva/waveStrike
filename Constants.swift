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
        static let TargetImage1 = "ship_small_body" // patroller
        static let TargetImage2 = "ship_small_b_body" // shooter
        static let TargetImage3 = "ship_gun_base_destroyed" // mine
        static let WaterRipple = "water_ripple_medium_000"
        static let WaterRippleEnemy = "water_ripple_small_000"
    }
    
    struct Sound {
        static let Cannon = "cannon.wav"
    }
    
    struct Scene {
        static let MainScreenBackgroundColor = UIColor(red: 76, green: 104, blue: 119)
        static let GameBackgroundColor = UIColor(red: 128, green: 158, blue: 169)
        static let WinBackgroundColor = UIColor(red: 99, green: 142, blue: 131)
        static let LoseBackgroundColor = UIColor(red: 54, green: 102, blue: 90)
    }
    
    struct TutorialStart {
        static let positions: [CGPoint] =
        [
            CGPoint(x : 350, y : 300),
            CGPoint(x : 350, y : -300),
            CGPoint(x : -350, y : 300),
            CGPoint(x : -350, y : -300)
        ]
        
        static let velocityDirs: [CGPoint] =
        [
            CGPoint(x : 0, y : 1),
            CGPoint(x : 0, y : 1),
            CGPoint(x : 0, y : -1),
            CGPoint(x : 0, y : -1)
        ]
    }
    
}