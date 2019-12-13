//
//  PNRefreshComponent.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/13.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNRefreshComponent: UIView {

    private var _scrollViewOriginalInset : UIEdgeInsets?
    private weak var _scrollView : UIScrollView?
    
    var scrollViewOriginalInset: UIEdgeInsets? {
        
        return nil
    }
    
    var scrollView: UIScrollView? {
        
        return nil
    }
    
    var isRefreshing : Bool {
        
        return state == PNRefreshState.loading || state == PNRefreshState.willLoad
    }
    
    var refreshingBlock : PNRefreshComponentAction!
    
    weak var refreshingTarget : AnyObject?
    var refreshAction : Selector?
    
    var begingRefreshingCompletionBlock : PNRefreshComponentAction!
    var endRefreshingAnimationBeginAction : PNRefreshComponentAction!
    var endRefreshingCompletionBlock : PNRefreshComponentAction!
    
    var state : PNRefreshState?

    var _pullingPercent : CGFloat? {
        
        set(newValue) {
            
            pullingPercent = newValue
            
            if isRefreshing {
                
                return
            }
            
            if isAuto
        }
        
        get {
            
            return pullingPercent
        }
    }
    
    var pullingPercent : CGFloat?
    
    var automaticallyChangeAlpha: Bool? {
        
        return nil
    }
    
    func setRefreshing(target : AnyObject?, action : Selector?) {
        
        
    }
    
    func executeRefreshingCallback() {
        
        let asyncQueue = DispatchQueue.init(label: "com.pn.refresh.excute")
        
        DispatchQueue.main.async {
            
            self.excecute()
        }
    }
    
    private func excecute() {
        
        if refreshingBlock != nil {
            
            refreshingBlock()
        }
        
        if self.refreshingTarget?.responds(to: self.refreshAction) != nil {
            
            refreshingTarget?.perform(refreshAction, with: self)
        }
        
        if begingRefreshingCompletionBlock != nil {
            
            begingRefreshingCompletionBlock()
        }
        
    }
    
    func begingRefreshing() {
        
        
    }
    
    func begingRefreshing(CompletionBlock : PNRefreshComponentAction?) {
        
        
    }
    
    func endRefreshing() {
        
        
    }
    
    func endRefreshing(CompletionBlock : PNRefreshComponentAction?) {
        
        
    }
    
    func prepare() {
        
        
    }
    
    func placeSubviews() {
        
        
    }
    
    func scrollViewContentOffsetDidChange(change : NSDictionary?) {
        
        
    }
    
    func scrollViewContentSizeDidChange(change : NSDictionary?) {
        
        
    }
    
    func scrollViewPanStateDidChange(change : NSDictionary?) {
        
        
    }
    
}

extension PNRefreshComponent {
    
    enum PNRefreshState {
        case idle
        case pulling
        case loading
        case willLoad
        case noMoreData
    }
    
    typealias PNRefreshComponentAction = () -> ()
}

extension UILabel {
    
    class func pn_label() -> UILabel {
        
        let label : UILabel = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = UIColor.colorWithRGB(rgb: 0x666666)
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        
        return label
    }
    
    func pn_textWidth() -> CGFloat{
        
        var stringWidth : CGFloat = 0.0
        
        if self.attributedText != nil {
            
            if self.attributedText?.length == 0 {
                
                return 0
            }
            
            stringWidth = (self.attributedText?.size().width)!
            
        }else {
            
            if self.text?.count == 0 {
                
                return 0
            }
            
            let attr = NSAttributedString.init(string: self.text!, attributes: [NSAttributedString.Key.font : self.font as Any])
            
            stringWidth = attr.size().width
            
        }
        
        return stringWidth
    }
}