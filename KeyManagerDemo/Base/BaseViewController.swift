//
//  BaseViewController.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var navBGColor: UIColor {
        get {
            
            return navColor ?? .white
        }
        set {
            navColor = newValue
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.initWithColor(color: navColor!), for: .any, barMetrics: .default)
        }
    }
    
    var navColor : UIColor?
    
    lazy var navTitleLabel: UILabel = {
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100.0, height: 40.0))
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    lazy var topView: UIView = {
        
        let topView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100.0))
        
        return topView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUISet()
    }
    
    func configUISet() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.initWithColor(color: .white), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.tintColor = .white
        
        self.view.backgroundColor = .white
    }

}

extension BaseViewController {
    
    func setPageTitleByName(title : String) {
        
        navTitleLabel.text = title
        self.navigationItem.titleView = self.navTitleLabel
    }
}
