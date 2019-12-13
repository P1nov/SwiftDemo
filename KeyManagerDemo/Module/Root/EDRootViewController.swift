//
//  EDRootViewController.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/12.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class EDRootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.bool(forKey: "authenticationIsOn") {
            
            self.loadAuthenticationPageModule()
        }else {
            
            self.loadMainPageModule()
        }
        
    }

}

extension UITabBarController {
    
    func loadAuthenticationPageModule() {
        
        self.tabBar.isHidden = true
        
        let controller : EdAuthenicationViewController = EdAuthenicationViewController()
        
        self.viewControllers = [controller]
    }
    
    func loadMainPageModule() {
        
        self.tabBar.isHidden = true
        
        let controller : MainPageControllerViewController = MainPageControllerViewController()
        
        let mainNav = UINavigationController(rootViewController: controller)
        
        self.viewControllers = [mainNav]
    }
}
