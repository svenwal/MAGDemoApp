//
//  SecondViewController.swift
//  Team1Bank
//
//  Created by Sven Walther on 19.09.18.
//  Copyright © 2018 Sven Walther. All rights reserved.
//

import UIKit
import MASFoundation
import MASIdentityManagement
import MASConnecta

class ChatViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        usernameTextField.placeholder = "Message to?"
        //messageTextField.placeholder = "Enter the message that you want to send"
        
        // add an observer that is later used to handle incoming messages
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.didReceiveMessageNotification(notification:)),
            name: NSNotification.Name(rawValue: MASConnectaMessageSentNotification),
            object: nil)
        
        // start the listener
        MASUser.current()!.startListening(toMyMessages: {(success , error)  in
            if success {
                print("Success subscribing to myUser topic!")
            } else {
                print(error?.localizedDescription as Any)
            }
        })
        
        MAS.setGatewayNetworkActivityLogging(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc  func didReceiveMessageNotification(notification: NSNotification){
        //
        //Get the Message Object from the notification
        //
        weak var weakSelf = self
        
        DispatchQueue.main.async(execute: {() -> Void in
            
            let myMessage = notification.userInfo![MASConnectaMessageKey] as! MASMessage
            
            //weakSelf.profileImage.image = myMessage.payloadTypeAsImage
            //weakSelf.messagePayload.text = myMessage.payloadTypeAsString
            let displayString = "message TO \(myMessage.receiverObjectId!) received FROM \(myMessage.senderDisplayName!): \(myMessage.payloadTypeAsString()!)"
            
            print(displayString)
            self.resultTextView.text = self.resultTextView.text  + displayString
        }
        )}
    
    @IBAction func sendMessage(_ sender: Any) {
        let myUser = MASUser.current()

//        myUser?.sendMessage(self.messageTextField.text! as NSObject, to: usernameTextField.text!, completion: { (success, error) in
//            let response = (success == true) ? "Message sent" : "\(error!)"
//            print(response)
//        })

        MASUser.getUserByUserName(usernameTextField.text!) { (thisUser, error) in
            if error != nil {
                print("Chat error: \(error)")
            } else {
                myUser?.sendMessage(self.messageTextField.text! as NSObject, to: thisUser!, completion: { (success, error) in
                    let response = (success == true) ? "Message sent" : "\(error!)"
                    print(response)
                })
            }
        }
        

    }
}


