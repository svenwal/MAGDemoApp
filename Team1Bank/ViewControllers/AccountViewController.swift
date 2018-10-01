//
//  SecondViewController.swift
//  Team1Bank
//
//  Created by Sven Walther on 19.09.18.
//  Copyright © 2018 Sven Walther. All rights reserved.
//

import UIKit
import MASFoundation

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewBalanceTouch(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func myProfileTouched(_ sender: Any) {
        self.tabBarController?.selectedIndex = 4
    }
    
    @IBAction func transferMoneyTouch(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func chatTouched(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func creditsTouched(_ sender: Any) {
        self.tabBarController?.selectedIndex = 6
    }
    
    @IBAction func logoutTouch(_ sender: Any) {
        MASUser.current()?.logout(true, completion: { (completed, error) in
            
            if error != nil {
                
            }  else {
//                self.tabBarController?.viewControllers?.insert(HomeViewController.self(), at: 0)
                self.tabBarController?.selectedIndex = 0
                self.tabBarController?.tabBar.isHidden = true
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                storyboard.instantiateInitialViewController()
            }}
    )
    }
}

