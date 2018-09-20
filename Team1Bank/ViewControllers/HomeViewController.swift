//
//  HomeViewController.swift
//  Team1Bank
//
//  Created by Sven Walther on 19.09.18.
//  Copyright © 2018 Sven Walther. All rights reserved.
//

import UIKit
import MASFoundation
import MASUI

class HomeViewController: UIViewController {

    @IBOutlet weak var tabbar: UITabBarItem!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBarController?.tabBar.isHidden = true
        
        MAS.setGrantFlow(MASGrantFlow.password)
        MAS.start(withDefaultConfiguration: true) { (Completed, error) in
            //            MAS.currentStatusToConsole()
        }
        if MASUser.current() != nil {
            self.loginSuccessful()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTouch(_ sender: Any) {
    
        if MASUser.current() == nil {
        MASUser.presentLoginViewController { (success, error) in
            if(error != nil) {
                //self.resultTextView.text = "Error logging in: \(error!)"
            }
            else
            {
                // after succesful login
               self.loginSuccessful()
                
                
            }
        }
        }
        else
        {
            MASUser.current()?.logout(true, completion: { (completed, error) in
                
                if error != nil {
                    
                }  else {
                    self.tabBarController?.tabBar.isHidden = true
                    
                    self.tabBarController?.selectedIndex = 0
                    
                    self.loginButtonOutlet.setTitle("Log into account", for: .normal)
                }
            })
        }
        
  

        

        
    }
    
    func loginSuccessful() {
        // after succesful login
        self.tabBarController?.tabBar.isHidden = false
        
        self.tabBarController?.selectedIndex = 1
        
        self.loginButtonOutlet.setTitle("Logout", for: .normal)
    }
    
}

