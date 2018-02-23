//
//  AlertHandler.swift
//  Flash Chat
//
//  Created by Carlos Herrera Somet on 15/2/18.
//  Copyright © 2018 csomet. All rights reserved.
//


import UIKit
import DropdownAlert


/**
    This class manage alerts and error to be shown in the App.
 - author: Carlos H Somet
 - important: You don't need to instantiate this class
 - version: 1.0
 
 **/
class AlertHandler {
    
    
    /**
     It shows confirmations alerts in the system. It uses DropdownAlert.
     - parameter title: The title for the alert.
     - parameter message: The message desired to be displayed.
     */
    static func showOK(title: String, message: String){
        
        DropdownAlert.showWithAnimation(animationType: .Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)), title: title, message: message, backgroundColor: Constants.Alerts.Colors.OK_BACKGROUND_COLOR, textColor: Constants.Alerts.Colors.TEXT_OK_COLOR, duration: Constants.Alerts.Duration.ALERT_DURATION)
        
    }
    
    
    /**
     It shows information alerts in the system. It uses DropdownAlert.
     - parameter title: The title for the alert.
     - parameter message: The message desired to be displayed.
     */
    static func showInformation(title: String, message: String){
        
        DropdownAlert.showWithAnimation(animationType: .Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)), title: title, message: message, backgroundColor: Constants.Alerts.Colors.INF_BACKGROUND_COLOR, textColor: Constants.Alerts.Colors.TEXT_INF_COLOR, duration: Constants.Alerts.Duration.ALERT_DURATION)
        
    }
    
    
    /**
     It shows error messages in the system. It uses DropdownAlert.
     - parameter title: The title for the alert.
     - parameter message: The message desired to be displayed.
     */
    static func showError(title: String, message: String){
        
       DropdownAlert.showWithAnimation(animationType: .Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)), title: title, message: message, backgroundColor: Constants.Alerts.Colors.ERR_BACKGROUND_COLOR, textColor: Constants.Alerts.Colors.TEXT_ERR_COLOR, duration: Constants.Alerts.Duration.ALERT_DURATION)
        
    }
    
    
}
