//
//  SystemConstants.swift
//  Flash Chat
//
//  Created by Carlos Herrera Somet on 15/2/18.
//  Copyright © 2018 csomet. All rights reserved.
//


import UIKit


struct Constants {
    
    struct Messages {
        static let LOGIN_OK_MESSAGE    = "Hi! You are logged in."
        static let LOGIN_ERR_MESSAGE   = "Oops! You are not logged in."
        static let GENERIC_ERR_TITLE   = "Opps! Something wrong occurred..."
        static let GENERIC_ALERT_TITLE = "Attention"
    }
    
    struct Alerts {
        
        struct Colors {
            static let ERR_BACKGROUND_COLOR = UIColor(red: 239/255, green: 35/255, blue: 73/255, alpha: 0.91)
            static let OK_BACKGROUND_COLOR  = UIColor(red: 25/255, green: 29/255, blue: 134/255, alpha: 0.91)
            static let INF_BACKGROUND_COLOR = UIColor(red: 23/255, green: 183/255, blue: 237/255, alpha: 0.91)
            static let TEXT_ERR_COLOR       = UIColor.white
            static let TEXT_INF_COLOR       = UIColor.white
            static let TEXT_OK_COLOR        = UIColor.white
        }
        
        struct Duration {
            static let ALERT_DURATION = 3.2
        }
    }
    
    struct Sounds {
        
        static let MESSAGE_SOUND  = Bundle.main.url(forResource: "message", withExtension: "wav")
        
    }
    
    
    
}
