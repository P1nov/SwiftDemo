//
//  UIImage+Extension.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/10.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func initWithColor(color : UIColor, size : CGSize) -> UIImage {
        
        let rect = CGRect.init(origin: CGPoint.init(x: 0.0, y: 0.0), size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
    class func initWithColor(color : UIColor) -> UIImage {
        
        return initWithColor(color: color, size: CGSize.init(width: 1.0, height: 1.0))
    }
    
}
