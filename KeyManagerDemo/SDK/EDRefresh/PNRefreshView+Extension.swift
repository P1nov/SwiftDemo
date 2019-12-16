//
//  PNRefreshView+Extension.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/16.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

extension UIView {
    
    var mj_x : CGFloat {
        
        get {
            
            return self.frame.origin.x
        }
        
        set(newValue) {
            
            var frame = self.frame
            frame.origin.x = newValue
            
            self.frame = frame
        }
    }
    
    var mj_y : CGFloat {
        
        get {
            
            return self.frame.origin.y
        }
        
        set(newValue) {
            
            var frame = self.frame
            frame.origin.y = newValue
            
            self.frame = frame
        }
    }
    
    var mj_w : CGFloat {
        
        get {
            
            return self.frame.size.width
        }
        
        set(newValue) {
            
            var frame = self.frame
            frame.size.width = newValue
            
            self.frame = frame
        }
    }
    
    var mj_h : CGFloat {
        
        get {
            
            return self.frame.height
        }
        
        set(newValue) {
            
            var frame = self.frame
            frame.size.height = newValue
            
            self.frame = frame
        }
    }
    
    var mj_size : CGSize {
        
        get {
            
            return self.frame.size
        }
        
        set(newValue) {
            
            var frame = self.frame
            frame.size = newValue
            
            self.frame = frame
        }
    }
    
    var mj_origin : CGPoint {
        
        get {
            
            return self.frame.origin
        }
        
        set(newValue) {
            
            var frame = self.frame
            frame.origin = newValue
            
            self.frame = frame
        }
    }
}
