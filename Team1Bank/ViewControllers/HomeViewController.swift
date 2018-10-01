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
    
    var firstStart = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBarController?.tabBar.isHidden = true
        
        MAS.setGrantFlow(MASGrantFlow.password)
        MAS.start(withDefaultConfiguration: true) { (Completed, error) in
            //            MAS.currentStatusToConsole()
        }

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstStart {
            if(MASUser.current() != nil)
            {
                if (MASUser.current()?.isAuthenticated)!  {
                    self.loginSuccessful()
                }
            
            }
        }
        firstStart = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTouch(_ sender: Any) {
        if MASUser.current() != nil {
            if (MASUser.current()?.isAuthenticated)! {
                MASUser.current()?.logout(true, completion: { (completed, error) in
                
                if error != nil {
                    
                }  else {
                    //self.tabBarController?.viewControllers?.insert(self, at: 0)
                    self.tabBarController?.tabBar.isHidden = true
                    
                    self.tabBarController?.selectedIndex = 0
                    
                    self.loginButtonOutlet.setTitle("Log into account", for: .normal)
                    
                }
            })
            
            }
            else
            {
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
 
        }
        else
        {
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
        
  

        

        
    }
    
    func loginSuccessful() {
        // after succesful login
        self.tabBarController?.tabBar.isHidden = false
        self.loginButtonOutlet.setTitle("Relogin", for: .normal)
        
        self.tabBarController?.selectedIndex = 4
        //self.tabBarController?.viewControllers?.remove(at: 0)
      
    }
    
}

