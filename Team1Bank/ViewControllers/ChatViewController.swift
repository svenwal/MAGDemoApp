//
//  ChatViewController.swift
//  Team1Bank
//
//  Created by Sven Walther on 19.09.18.
//  Copyright © 2018 Sven Walther. All rights reserved.
//

import UIKit
import MASFoundation
import MASIdentityManagement
import MASConnecta

class ChatViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var receipientTextField: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var chatMessages: [MASMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receipientTextField.delegate = self
        messageTextField.delegate = self
        
        // add an observer that is later used to handle incoming messages
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(self.didReceiveMessageNotification(notification:)),
                                                name: NSNotification.Name(rawValue: MASConnectaMessageReceivedNotification),
                                                object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveMessageNotification(notification:)),
                                               name: NSNotification.Name(rawValue:
                                                    MASConnectaMessageSentNotification),
                                               object: nil)
        
        MAS.setGatewayNetworkActivityLogging(true)
        // start the listener
        MASUser.current()!.startListening(toMyMessages: {(success , error)  in
            if success {
                print("Success subscribing to myUser topic!")
            } else {
                print(error?.localizedDescription as Any)
            }
        })
                
        tableViewOutlet.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc  func didReceiveMessageNotification(notification: NSNotification){
        DispatchQueue.main.async(execute: {() -> Void in
            
            let myMessage = notification.userInfo![MASConnectaMessageKey] as! MASMessage

            let displayString = "TO \(myMessage.receiverObjectId!) FROM \(myMessage.senderDisplayName!): \(myMessage.payloadTypeAsString()!)\n"
            print(displayString)
            
            self.chatMessages.append(myMessage)
            if let tabItems = self.tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[3]
                tabItem.badgeValue = "\(self.chatMessages.count)"
            }
            self.tableViewOutlet.reloadData()
        }
        )}
    
    @IBAction func sendMessage(_ sender: Any) {
        let myUser = MASUser.current()

        self.resignFirstResponder()
        
        MASUser.getUserByUserName(receipientTextField.text!) { (thisUser, error) in
            if error != nil {
                print("Chat error: \(error!)")
            } else {
                myUser?.sendMessage(self.messageTextField.text! as NSObject, to: thisUser!, completion: { (success, error) in
                    let response = (success == true) ? "Message sent" : "\(error!)"
                    print(response)
                })
            }
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row >= chatMessages.count)
        {
            print("Wrong row number detected")
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableCell") as! ChatTableViewCell
            cell.payloadOutlet?.text = "Something went wrong"
            return cell
        }
        print("Added row to table view")
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableCell") as! ChatTableViewCell
        
        
        let message = chatMessages[indexPath.row]
        print(indexPath.row)
        print(message.senderTypeAsString())
        print(message.payloadTypeAsString())
        
        let myUser = MASUser.current()
        if(myUser?.userName == message.senderObjectId) {
            cell.avatarOutlet.alpha = 0.2
        }
        
        cell.senderOutlet.text = message.senderDisplayName
        cell.payloadOutlet.text = message.payloadTypeAsString()
        
        print(chatMessages)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func usernameEditingEnd(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func messageTextEditingEnd(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
}


