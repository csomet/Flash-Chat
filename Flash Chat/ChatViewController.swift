//
//  ViewController.swift
//  Flash Chat
//
//

import UIKit
import Firebase
import ChameleonFramework
import AVFoundation

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var player : AVAudioPlayer?
    var activeSound : Bool = false
    
    override var disablesAutomaticKeyboardDismissal: Bool {
        get { return false } // or false
        set { }
    }
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    var keyboardHeight : CGFloat?

    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        self.navigationItem.hidesBackButton = true

        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        getMessagesFromDB()
        
        //We make sure sound message alert doesn't sound at first time when the view appears.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            
            self.activeSound = true
            
        })
 
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].message
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named:"egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.messageBackground.backgroundColor = UIColor.flatGreen()
            cell.avatarImageView.backgroundColor = UIColor.flatLime()
            cell.avatarImageView.image = UIImage(named: "user1")
        } else {
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            cell.avatarImageView.backgroundColor = UIColor.flatPink()
            cell.avatarImageView.image = UIImage(named: "user2")
        }
        
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
       
        messageTextfield.endEditing(true)
    }

    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
        messageTableView.separatorStyle = .none
    }
    
    
    ///////////////////////////////////////////
  //MARK:- TextField Delegate Methods
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50 + keyboardHeight
        }
        
        view.layoutIfNeeded()
        
        if (self.messageArray.count - 1) >=  0 {
            let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
      
        UIView.animate(withDuration: 0.5) {
             self.heightConstraint.constant = 50
        }
        
        view.layoutIfNeeded()
       
        if (self.messageArray.count - 1) >=  0 {
            let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
  
    
    
    /**
     It plays the message received sound
     */
    func playMessageSound(){
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: Constants.Sounds.MESSAGE_SOUND!, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            player.play()
            
            
        } catch {
             print(error.localizedDescription)
        }
        
        
        
    }
    
    
    
    ////////////////////////
    
 
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        if messageTextfield.text != "" {
            
        
            sendButton.isEnabled = false
            
            
            let messageDict : [String : String]  = ["Sender" : (Auth.auth().currentUser?.email)!,
                                                    "MessageBody" : messageTextfield.text!]
            
            let messageDB = Database.database().reference().child("Messages")
            
            messageDB.childByAutoId().setValue(messageDict) {
                (error, reference) in
                
                if error != nil {
                    
                    AlertHandler.showError(title: "Error", message: (error?.localizedDescription)!)
                } else {
                    self.messageTextfield.text = ""
                    self.sendButton.isEnabled = true
                    
                    if (self.messageArray.count - 1) >=  0 {
                        let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
                        self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                    
                }
                
            }
        
        }
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func getMessagesFromDB(){
        
        let messageDB = Database.database().reference().child("Messages")
        
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotData = snapshot.value as! Dictionary<String, String>
            let message = Message(snapshot: snapshotData)
            self.messageArray.append(message)
            self.messageTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
         
            if self.activeSound && Auth.auth().currentUser?.email != message.sender {
               self.playMessageSound()
            }
            
            if (self.messageArray.count - 1) >=  0 {
                let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
                self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
        
        
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch  {
            AlertHandler.showError(title: "Error!", message: error.localizedDescription)
        }
        
    }
    


}
