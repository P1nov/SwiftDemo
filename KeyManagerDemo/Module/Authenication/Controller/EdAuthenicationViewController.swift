//
//  EdAuthenicationViewController.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/11.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class EdAuthenicationViewController: BaseViewController {
    
    lazy var fingerPrintImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var tipLabel : UILabel = {
       
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .black
        
        return label
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUISet() {
        super.configUISet()
        
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(fingerPrintImageView)
        self.view.addSubview(tipLabel)
        
        fingerPrintImageView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200.0)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(fingerPrintImageView.snp_bottom).offset(100.0)
        }
        
        if AuthenticationManager.checkUnLockSupportType() == .faceID {
            
            tipLabel.text = "验证您的faceID"
            fingerPrintImageView.image = UIImage(named: "FaceID")
        }else if AuthenticationManager.checkUnLockSupportType() == .touchID {
            
            tipLabel.text = "验证您的touchID"
            fingerPrintImageView.image = UIImage(named: "ed_finger_print")
        }else {
            
            tipLabel.text = "输入您的密码"
            fingerPrintImageView.image = UIImage(named: "password_verify")
        }
        
        AuthenticationManager.unlock(with: .success) { (result, errorMsg) in
            
            if result == .success {
                
                print("验证成功！")
                DispatchQueue.main.async {
                    
                    self.tabBarController?.loadMainPageModule()
                }
            }else {
                
                print(errorMsg)
            }
        }
        
    }

}
