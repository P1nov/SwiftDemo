//
//  UIViewController+Extension.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/11.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @objc private func dismissPopUpViewController(viewController : UIViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
}
