//
//  UIColor+Extension.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/10.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithRGBA(rgb : Int32, alpha : CGFloat) -> UIColor {
        
        let r : CGFloat = CGFloat(Double((rgb & 0xFFFFFF) >> 16) / 255.0)
        let g : CGFloat = CGFloat(Double((rgb & 0xFFFF) >> 8) / 255.0)
        let b : CGFloat = CGFloat(Double((rgb & 0xFF)) / 255)
        
        return self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    class func colorWithRGB(rgb : Int32) -> UIColor {
        
        return colorWithRGBA(rgb: rgb, alpha: 1.0)
    }
}
