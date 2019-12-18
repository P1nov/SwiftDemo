//
//  PNRefreshFooter.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/18.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNRefreshFooter: PNRefreshComponent {
    
    class func footer(with refreshingBlock : PNRefreshComponentAction?) -> PNRefreshFooter? {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock!
        
        return cmp
    }
    
    class func footer(with refreshingTarget : AnyObject?, action : Selector?) -> PNRefreshFooter? {
        
        let cmp = self.init()
        cmp.setRefreshing(target: refreshingTarget, action: action)
        
        return cmp
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
    }

    override func endRefreshing() {
        
        super.endRefreshing()
        
        DispatchQueue.main.async {
            
            self.setState(newState: .idle)
        }
    }
    
    override func prepare() {
        super.prepare()
        
        self.mj_h = CGFloat(PNRefreshFooterHeight)
    }
    
    func endRefreshWithNoMoreData() {
        
        DispatchQueue.main.async {
            
            self.setState(newState: .noMoreData)
        }
    }
    
    func resetNoMoreData() {
        
        DispatchQueue.main.async {
            
            self.setState(newState: .idle)
        }
    }
    
    
    
    override func begingRefreshing() {
        super.begingRefreshing()
        
        UIView.animate(withDuration: 0.25) {
            
            self.alpha = 1.0
        }
        
        pullingPercent = 1.0
        
        if self.window != nil {
            
            self.setState(newState: .loading)
        }else {
            
            if state != .loading {
                
                self.setState(newState: .willLoad)
                
                self.setNeedsDisplay()
            }
        }
    }
    
    override func scrollViewContentOffsetDidChange(change: NSDictionary?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        
    }
    
    override func scrollViewContentSizeDidChange(change: NSDictionary?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
    }
    
    override func setState(newState: PNRefreshComponent.PNRefreshState) {
        super.setState(newState: newState)
        
        
    }
}
