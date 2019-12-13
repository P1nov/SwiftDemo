//
//  EDPopUpHUD.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/11.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class EDPopUpHUD: UIView {
    
    var graceTime : Timer?
    
    class func popUpMessage(message : String, in view : UIView) {
        
        let messageLabel : UILabel = UILabel()
        messageLabel.clipsToBounds = true
        messageLabel.layer.cornerRadius = 8.0
        messageLabel.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        messageLabel.text = message
        
        messageLabel.alpha = 0.0
        
        let hud : EDPopUpHUD = EDPopUpHUD()
        
        hud.addSubview(messageLabel)
        hud.removeFromSuperview()
        
        view.addSubview(hud)
        
        messageLabel.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            
            messageLabel.alpha = 1.0
            
        }) { (completed) in
            
            messageLabel.alpha = 1.0
        }
        
        self.perform(#selector(hideAnimated(hud:)), with: hud, afterDelay: 2.0, inModes: [.common])
    }
    
    @objc func hideAnimated(hud : EDPopUpHUD) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            hud.alpha = 0.0
            
        }) { (completed) in
            
            hud.removeFromSuperview()
        }
    }
    
}
