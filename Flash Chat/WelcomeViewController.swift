//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import Firebase


class WelcomeViewController: UIViewController {

    var handler : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Check if we are already logged in so we don't need to go through Login Screen
        //in the navigationController.
        
        handler = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user != nil {
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let chatVC = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! ChatViewController
                
                self.navigationController?.pushViewController(chatVC, animated: true)
                
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        Auth.auth().removeStateDidChangeListener(handler!)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
