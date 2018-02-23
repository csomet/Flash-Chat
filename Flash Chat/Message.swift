//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

class Message {
    
    
    var message : String?
    var sender: String?
    
    init(message: String, sender: String){
        
        self.message = message
        self.sender = sender
    }
    
    /**
     Use this method to retrieve information of Dictionary and create the instance.
     */
    init(snapshot: [String : String]){
        self.message = snapshot["MessageBody"]
        self.sender  = snapshot["Sender"]
    }
    
}
