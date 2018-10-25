//
//  SecondViewController.swift
//  Team1Bank
//
//  Created by Sven Walther on 19.09.18.
//  Copyright © 2018 Sven Walther. All rights reserved.
//

import UIKit
import MASFoundation

class TransferViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var balanceOutlet: UILabel!
    
    @IBOutlet weak var amountOutlet: UITextField!
    
    @IBOutlet weak var targetAccountOutlet: UITextField!
    
    @IBOutlet weak var sendMoneyButtonOutlet: UIButton!
    
    @IBOutlet weak var successLabelOutlet: UILabel!
    
    var successTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        sendMoneyButtonOutlet.isEnabled = false
        sendMoneyButtonOutlet.alpha = 0.3
        successLabelOutlet.isHidden = true
        
        let builder = MASRequestBuilder.init(httpMethod: "GET")
        builder.endPoint = "/mws-team1/account/balance?accountId=604"
        builder.isPublic = false
        builder.responseType = .json
        
        MAS.invoke(builder.build()!) { (httpresponse, response, error) in
            if response != nil {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                    print(">>>>>>>>> jsonData")
                    print(jsonData)
                    
                    let balance = try JSONDecoder().decode(Balance.self, from: jsonData)
                    self.balanceOutlet.text = "Your balance is \(balance.balance)"
                }
                catch
                {
                    print(error)
                }
            }
            else if error != nil
            {
                self.balanceOutlet.text = "Not able to connect to backend"
                print("error when calling API: \(error!)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func amountChanged(_ sender: Any) {
        if(amountOutlet.text!.count > 0 && targetAccountOutlet.text!.count > 0) {
            sendMoneyButtonOutlet.isEnabled = true
            sendMoneyButtonOutlet.alpha = 0.8
        }
        else
        {
            sendMoneyButtonOutlet.isEnabled = false
            sendMoneyButtonOutlet.alpha = 0.3
        }
    }
    
    @IBAction func targetChanged(_ sender: Any) {
        if(amountOutlet.text!.count > 0 && targetAccountOutlet.text!.count > 0) {
            sendMoneyButtonOutlet.isEnabled = true
            sendMoneyButtonOutlet.alpha = 0.8
        }
        else
        {
            sendMoneyButtonOutlet.isEnabled = false
            sendMoneyButtonOutlet.alpha = 0.3
        }
    }
    
    @IBAction func tagetAccdidBegin(_ sender: Any) {
        sendMoneyButtonOutlet.isEnabled = true
        sendMoneyButtonOutlet.alpha = 0.8
    }
    
    
    @IBAction func sendMoneyTouch(_ sender: Any) {
        
        let amount = amountOutlet.text
        let targetAccount = targetAccountOutlet.text
        
        balanceOutlet.resignFirstResponder()
        targetAccountOutlet.resignFirstResponder()
        
        
        let builder = MASRequestBuilder.init(httpMethod: "GET")
        builder.endPoint = "/mws-team1/newtransfer?amount=\(amount!)&toAccountId=\(targetAccount!)&fromAccountId=604"
        builder.isPublic = false
        builder.responseType = .json
        
        MAS.invoke(builder.build()!) { (httpresponse, response, error) in
            if response != nil {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                    print(">>>>>>>>> jsonData")
                    print(jsonData)
                    
                    let transferResult = try JSONDecoder().decode(TransferResult.self, from: jsonData)
                    if transferResult.status == 200 {
                        self.balanceOutlet.text = "Your new balance: \(transferResult.balance)"
                        self.showResponse(text: nil, success: true)
                    }
                    else
                    {
                        self.showResponse(text: nil, success: false)
                    }
                }
                catch
                {
                    print(error)
                }
                
            }
            else if error != nil
            {
                print(error!)
                //self.balanceOutlet.text = "Not able to connect to backend"
                //print("error when calling API: \(error)")
            }
        }
        
    }
    
    func showResponse(text: String?, success: Bool) {
        var displayText: String
        
        if text == nil && success == true
        {
            displayText = "Money transfered"
        }
        else if text == nil && success == false
        {
            displayText = "Transfer failed"
        }
        else
        {
            displayText = text!
        }
        
        if success == true {
            successLabelOutlet.backgroundColor = UIColor(displayP3Red: 1/255, green: 202/255, blue: 1/255, alpha: 0.8)
            balanceOutlet.backgroundColor = UIColor(displayP3Red: 1/255, green: 202/255, blue: 1/255, alpha: 0.8)
            
        } else {
            successLabelOutlet.backgroundColor = UIColor(displayP3Red: 202/255, green: 1/255, blue: 1/255, alpha: 0.8)
        }
        
        successLabelOutlet.text = displayText
        
        successLabelOutlet.isHidden = false
        
        successTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideSuccess), userInfo: nil, repeats: false)
    }
    
    @objc func hideSuccess() {
        successTimer.invalidate()
        successLabelOutlet.isHidden = true
        balanceOutlet.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
}

