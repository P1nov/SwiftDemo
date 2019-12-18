//
//  PNRefreshHeader.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/16.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

@objc class PNRefreshHeader: PNRefreshComponent, CAAnimationDelegate {
    
    static var PNRefreshHeaderRefreshing2IdleBoundsKey : String = "PNRefreshHeaderRefreshing2IdleBounds"
    static var PNRefreshHeaderRefreshingBoundsKey : String = "PNRefreshHeaderRefreshingBounds"

    var lastUpdatedTimeKey : String?
    
    var lastUpdatedTime : Date? {
        
        get {
            
            return (UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey!) as! Date)
        }
    }
    
    var ignoredScrollViewContentInsetTop_ : CGFloat? {
        
        get {
            
            return self.ignoredScrollViewContentInsetTop!
        }
        
        set(newValue) {
            
            ignoredScrollViewContentInsetTop = newValue
            
            self.mj_y = -self.mj_h - ignoredScrollViewContentInsetTop!
        }
    }
    
    var ignoredScrollViewContentInsetTop : CGFloat?
    
    var insetDelta : CGFloat?
    
    class func header(with refreshingBlock : PNRefreshComponentAction?) -> PNRefreshHeader {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        
        return cmp
    }
    
    class func header(with refreshingTarget : AnyObject?, action : Selector?) -> PNRefreshHeader {
        
        let cmp = self.init()
        
        cmp.setRefreshing(target: refreshingTarget, action: action)
        
        return cmp
    }
    
    override func prepare() {
        
        super.prepare()
        
       self.lastUpdatedTimeKey = PNRefreshHeaderLastUpdatedTimeKey
              
       self.mj_h = CGFloat(PNRefreshHeaderHeight)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        self.mj_y = -self.mj_h - (self.ignoredScrollViewContentInsetTop ?? 0.0)
    }
    
    func resetInset() {
        
        if #available(iOS 11.0, *) {
            
        }else {
            
            if self.window == nil {
                
                return
            }
        }
        
        var insetT = -self.scrollView!.mj_offsetY > scrollViewOriginalInset!.top ? -self.scrollView!.mj_offsetY : scrollViewOriginalInset!.top
        
        insetT = insetT > self.mj_h + scrollViewOriginalInset!.top ? self.mj_h + scrollViewOriginalInset!.top : insetT
        
        self.insetDelta = scrollViewOriginalInset!.top - insetT
        
        if self.scrollView?.mj_insetT != insetT {
            
            self.scrollView?.mj_insetT = insetT
        }
        
    }
    
    override func scrollViewContentOffsetDidChange(change: NSDictionary?) {
        
        super.scrollViewContentOffsetDidChange(change: change)
        
        if state == .loading {
            
            self.resetInset()
            
            return
        }
        
        scrollViewOriginalInset = self.scrollView?.mj_inset
        
        //当前的偏移量
        let offsetY : CGFloat = self.scrollView!.mj_offsetY
        //头部控件刚好出现的offsetY
        let happenOffsetY : CGFloat = self.scrollViewOriginalInset!.top
        
        if offsetY > happenOffsetY {
            
            return
        }
        
        let normal2PullingOffsetY = happenOffsetY - self.mj_h
        let pullingPercent = (happenOffsetY - offsetY) / self.mj_h
        
        if self.scrollView!.isDragging {
            
            self.pullingPercent = pullingPercent
            
            if state == .idle && offsetY < normal2PullingOffsetY {
                
                setState(newState: .pulling)
            }else if state == .pulling && offsetY >= normal2PullingOffsetY {
                
                setState(newState: .idle)
            }
        }else if state == .pulling || state == .willLoad {
            
            self.begingRefreshing()
        }else if pullingPercent < 1 {
            
            self.pullingPercent = pullingPercent
        }
        
    }
    
    override func scrollViewContentSizeDidChange(change: NSDictionary?) {
        super.scrollViewContentSizeDidChange(change: change)
        
        
    }

    override func setState(newState: PNRefreshComponent.PNRefreshState) {
        super.setState(newState: newState)
        
//        if !PNRefresh.checkState(oldState: self.state, newState: newState) {
//
//            return
//
//        }
        
        state = newState
        
        DispatchQueue.main.async {
            
            super.setNeedsLayout()
        }
        
        if newState == .idle {
            
            UserDefaults.standard.set(NSDate(), forKey: self.lastUpdatedTimeKey!)
            UserDefaults.standard.synchronize()
            
            let viewalpha = self.alpha
            self.scrollView?.mj_insetT += self.insetDelta ?? 0
            self.scrollView?.isUserInteractionEnabled = false
            
            let boundsAnimation = CABasicAnimation.init(keyPath: "bounds")
            boundsAnimation.fromValue = self.scrollView!.bounds.offsetBy(dx: 0, dy: self.insetDelta ?? 0.0)
            boundsAnimation.duration = PNRefreshSlowAnimationDuration
            
            boundsAnimation.isRemovedOnCompletion = false
            boundsAnimation.fillMode = .both
            boundsAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            boundsAnimation.delegate = self
            
            self.scrollView?.layer.add(boundsAnimation, forKey: PNRefreshHeader.PNRefreshHeaderRefreshing2IdleBoundsKey)
            
            if endRefreshingCompletionBlock != nil {
                
                endRefreshingCompletionBlock()
            }
            
            if self.automaticallyChangeAlpha! {
                
                let opacityAnimation : CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
                opacityAnimation.fromValue = viewalpha
                opacityAnimation.toValue = 0.0
                opacityAnimation.duration = PNRefreshSlowAnimationDuration
                opacityAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
                
                self.layer.add(opacityAnimation, forKey: "MJRefreshHeaderRefreshing2IdleOpacity")
                
                self.alpha = 0.0
            }
        }else if state == .loading {
            
            if self.scrollView!.panGestureRecognizer.state != .cancelled {
                
                let top = self.scrollViewOriginalInset!.top + self.mj_h
                
                self.scrollView?.isUserInteractionEnabled = false
                
                let boundsAnimation : CABasicAnimation = CABasicAnimation.init(keyPath: "bounds")
                var bounds = self.scrollView!.bounds
                bounds.origin.y = -top
                
                boundsAnimation.fromValue = self.scrollView?.bounds
                boundsAnimation.toValue = bounds
                boundsAnimation.duration = PNRefreshFastAnimationDuration
                boundsAnimation.isRemovedOnCompletion = false
                boundsAnimation.fillMode = .both
                boundsAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
                boundsAnimation.delegate = self
                self.scrollView?.layer.add(boundsAnimation, forKey: PNRefreshHeader.PNRefreshHeaderRefreshingBoundsKey)
                
                
            }else {
                
                self.excecute()
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if anim.isEqual(self.scrollView?.layer.animation(forKey: PNRefreshHeader.PNRefreshHeaderRefreshing2IdleBoundsKey)) {
            
            self.scrollView?.layer.removeAnimation(forKey: PNRefreshHeader.PNRefreshHeaderRefreshing2IdleBoundsKey)
            
            self.pullingPercent = 0.0
            
            self.scrollView?.isUserInteractionEnabled = true
            
            if endRefreshingCompletionBlock != nil {
                
                endRefreshingCompletionBlock()
            }
        }
        
        if anim.isEqual(self.scrollView?.layer.animation(forKey: PNRefreshHeader.PNRefreshHeaderRefreshingBoundsKey)) {
            
            self.scrollView?.layer.removeAnimation(forKey: PNRefreshHeader.PNRefreshHeaderRefreshingBoundsKey)
            
            let top = self.scrollViewOriginalInset!.top + self.mj_h
            self.scrollView?.mj_insetT = top
            
            var offset = self.scrollView?.contentOffset
            offset!.y = -top
            
            self.scrollView?.setContentOffset(offset!, animated: false)
            
            self.scrollView?.isUserInteractionEnabled = true
            
            self.excecute()
        }
    }
    
    override func begingRefreshing() {
        super.begingRefreshing()
        
        UIView.animate(withDuration: 0.25) {
            
            self.alpha = 1.0
        }
        
        pullingPercent = 1.0
        
        if self.window != nil {
            
            setState(newState: .loading)
        }else {
            
            if state != .loading {
                
                setState(newState: .willLoad)
                
                self.setNeedsDisplay()
            }
        }
        
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        DispatchQueue.main.async {
            
            self.setState(newState: .idle)
        }
    }
}
