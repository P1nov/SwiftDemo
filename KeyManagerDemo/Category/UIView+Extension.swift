//
//  UIView+Extension.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/11.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

extension UIView{

    func getFirstViewController() -> UIViewController? {

        for view in sequence(first: self.superview, next: {$0?.superview}){

            if let responder = view?.next{

                if responder.isKind(of: UIViewController.self){

                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
