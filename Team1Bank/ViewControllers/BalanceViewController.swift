//
//  SecondViewController.swift
//  Team1Bank
//
//  Created by Sven Walther on 19.09.18.
//  Copyright © 2018 Sven Walther. All rights reserved.
//

import UIKit
import MASFoundation

class BalanceViewController: UIViewController {
    
    
    @IBOutlet weak var balanceOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
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
    
    @IBAction func transferButtonTouched(_ sender: Any) {
        self.tabBarController?.selectedIndex = 4
    }
    
    
    
}


