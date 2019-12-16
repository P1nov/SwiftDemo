//
//  PNRefreshScrollView+Extension.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/16.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    static var respondsToAdjustedContentInset_ : Bool?
    
    public class func initializeOnceMethod() {
        
        if #available(iOS 11.0, *) {
            respondsToAdjustedContentInset_ = self.instancesRespond(to: #selector(getter: UIScrollView.adjustedContentInset))
        } else {
            // Fallback on earlier versions
            respondsToAdjustedContentInset_ = self.instancesRespond(to: #selector(getter: UIScrollView.contentInset))
        }
    }
    
    var mj_inset : UIEdgeInsets {
        
        get {
            
            if #available(iOS 11.0, *) {
                
                if UIScrollView.respondsToAdjustedContentInset_! {
                    
                    return self.adjustedContentInset
                }
            }
            
            return self.contentInset
        }
    }
    
    var mj_insetT : CGFloat {
        
        get {
            
            return self.mj_inset.top
        }
        set(newValue) {
            
            var inset = self.contentInset
            inset.top = newValue
            
            if #available(iOS 11.0, *) {
                
                if UIScrollView.respondsToAdjustedContentInset_! {
                    
                    inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
                }
            }
            
            self.contentInset = inset
        }
    }
    
    var mj_insetB : CGFloat {
        
        get {
            
            return self.mj_inset.bottom
        }
        
        set(newValue) {
            
            var inset = self.contentInset
            inset.bottom = newValue
            
            if #available(iOS 11.0, *) {
                
                if UIScrollView.respondsToAdjustedContentInset_! {
                    
                    inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
                }
            }
            
            self.contentInset = inset
        }
    }
    
    var mj_insetL : CGFloat {
        
        get {
            
            return self.mj_inset.left
        }
        
        set(newValue) {
            
            var inset = self.contentInset
            inset.left = newValue
            
            if #available(iOS 11.0, *) {
                
                if UIScrollView.respondsToAdjustedContentInset_! {
                    
                    inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
                }
            }
            
            self.contentInset = inset
        }
    }
    
    var mj_insetR : CGFloat {
        
        get {
            
            return mj_inset.right
        }
        
        set(newValue) {
            
            var inset = self.contentInset
            inset.right = newValue
            
            if #available(iOS 11.0, *) {
                
                if UIScrollView.respondsToAdjustedContentInset_! {
                    
                    inset.right -= (self.adjustedContentInset.left - self.contentInset.left)
                }
            }
            
            self.contentInset = inset
        }
    }
    
    var mj_offsetX : CGFloat {
        
        get {
            
            return self.contentOffset.x
        }
        
        set(newValue) {
            
            var offset = self.contentOffset
            offset.x = newValue
            
            self.contentOffset = offset
        }
    }
    
    var mj_offsetY : CGFloat {
        
        get {
            
            return self.contentOffset.y
        }
        
        set(newValue) {
            
            var offset = self.contentOffset
            offset.y = newValue
            
            self.contentOffset = offset
        }
    }
    
    var mj_contentW : CGFloat {
        
        get {
            
            return self.contentSize.width
        }
        
        set(newValue) {
            
            var contentSize = self.contentSize
            contentSize.width = newValue
            
            self.contentSize = contentSize
        }
    }
    
    var mj_contentH : CGFloat {
        
        get {
            
            return self.contentSize.height
        }
        
        set(newValue) {
            
            var contentSize = self.contentSize
            contentSize.height = newValue
            
            self.contentSize = contentSize
        }
    }
}

extension UIScrollView {
    
//    var pn_header_ : PNRefreshHeader? {
//
//        get {
//
//            return pn_header
//        }
//
//        set(newValue) {
//
//            if newValue != pn_header {
//
//                self.pn_header?.removeFromSuperview()
//                self.insertSubview(newValue!, at: 0)
//
//                objc_setAssociatedObject(self, &UIScrollView.PNRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//            }
//        }
//    }
    
    @objc var pn_header : PNRefreshHeader? {
        
        get {
            
            let key = UnsafeRawPointer.init(bitPattern: "PNRefreshHeaderKey".hashValue)
            
            let header : PNRefreshHeader = objc_getAssociatedObject(self, key!) as! PNRefreshHeader
            
            return header
        }
        
        set(newValue) {
            
            newValue?.removeFromSuperview()
            newValue?.frame.size.width = self.frame.width
            self.insertSubview(newValue!, at: 0)
            
            let key = UnsafeRawPointer.init(bitPattern: "PNRefreshHeaderKey".hashValue)
            
            objc_setAssociatedObject(self, key!, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        }
    }
    
    func mj_totalDataCount() -> NSInteger {
        
        var totalCount : Int = 0
        
        if self.isKind(of: UITableView.self) {
            
            let tableView = self as! UITableView
            
            for index in 0 ..< tableView.numberOfSections {
                
                totalCount += tableView.numberOfRows(inSection: index)
            }
        }else if self.isKind(of: UICollectionView.self) {
            
            let collectionView = self as! UICollectionView
            
            for index in 0 ..< collectionView.numberOfSections {
                
                totalCount += collectionView.numberOfItems(inSection: index)
            }
        }
        
        return totalCount
    }
}
