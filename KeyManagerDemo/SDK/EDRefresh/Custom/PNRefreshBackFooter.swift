//
//  PNRefreshBackFooter.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/18.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNRefreshBackFooter: PNRefreshFooter {
    
    private var lastRefreshCount : Int?
    private var lastBottomDelta : CGFloat?
    
    var ignoredScrollViewContentInsetBottom : CGFloat?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.scrollViewContentSizeDidChange(change: nil)
    }
    
    override func scrollViewContentSizeDidChange(change: NSDictionary?) {
        super.scrollViewContentSizeDidChange(change: change)
        
        let contentHeight = self.scrollView!.mj_contentH + self.ignoredScrollViewContentInsetBottom!
        let scrollHeight = self.scrollView!.mj_h - self.scrollViewOriginalInset!.top - self.scrollViewOriginalInset!.bottom + self.ignoredScrollViewContentInsetBottom!
        
        self.mj_y = max(contentHeight, scrollHeight)
    }
    
    override func scrollViewContentOffsetDidChange(change: NSDictionary?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        if state == .loading {
            
            return
        }
        
        scrollViewOriginalInset = self.scrollView?.mj_inset
        
        //当前的offsetY
        let currentOffsetY = self.scrollView!.mj_offsetY
        //尾部视图刚好出现的offsetY
        let happenOffsetY = self.happenOffsetY()
        
        if currentOffsetY <= happenOffsetY {
            return
        }
        
        let pullingPercent = (currentOffsetY - happenOffsetY) / self.mj_h
        
        if state == .noMoreData {
            
            self.pullingPercent = pullingPercent
            return
        }
        
        if self.scrollView!.isDragging {
            
            self.pullingPercent = pullingPercent
            
            let normal2pullingOffsetY = happenOffsetY + self.mj_h
            
            if state == .idle && currentOffsetY > normal2pullingOffsetY {
                
                state = .pulling
            }else if state == .pulling && currentOffsetY <= normal2pullingOffsetY {
                
                state = .idle
            }
        }else if state == .pulling {
            
            self.begingRefreshing()
        }else if pullingPercent < 1{
            
            self.pullingPercent = pullingPercent
        }
        
    }
    
    private func happenOffsetY() -> CGFloat {
        
        let deltaH = self.heightForContentBreakView()
        
        if deltaH > 0 {
            
            return deltaH - scrollViewOriginalInset!.top
        }else {
            
            return -scrollViewOriginalInset!.top
        }
    }
    
    private func heightForContentBreakView() -> CGFloat {
        
        let h = self.scrollView!.frame.height - scrollViewOriginalInset!.bottom - scrollViewOriginalInset!.top
        
        return self.scrollView!.frame.height - h
    }
    
    override func setState(newState: PNRefreshComponent.PNRefreshState) {
        
        super.setState(newState: newState)
        
        let oldState = state
        
        state = newState
        
        if state == .noMoreData || state == .idle {
            
            if oldState == .loading {
                
                UIView.animate(withDuration: PNRefreshSlowAnimationDuration, animations: {
                    
                    if self.endRefreshingCompletionBlock != nil {
                        
                        self.endRefreshingCompletionBlock!()
                    }
                    
                    self.scrollView!.mj_insetB -= self.lastBottomDelta!
                    
                    if self.automaticallyChangeAlpha! {
                        
                        self.alpha = 0.0
                    }
                }) { (success) in
                    
                    self.pullingPercent = 0.0
                    
                    if self.endRefreshingCompletionBlock != nil {
                        
                        self.endRefreshingCompletionBlock!()
                    }
                }
            }
            
            let deltaH = self.heightForContentBreakView()
            
            if oldState == .loading && deltaH > 0 && self.scrollView!.mj_totalDataCount() != self.lastRefreshCount {
                
                self.scrollView?.mj_offsetY = self.scrollView!.mj_offsetY
            }
        }else if state == .loading {
            
            self.lastRefreshCount = self.scrollView?.mj_totalDataCount()
            
            UIView.animate(withDuration: PNRefreshFastAnimationDuration, animations: {
                
                var bottom = self.mj_h + self.scrollViewOriginalInset!.bottom
                let deltaH = self.heightForContentBreakView()
                
                if deltaH < 0 {
                    
                    bottom -= deltaH
                }
                
                self.lastBottomDelta = bottom - self.scrollView!.mj_insetB
                self.scrollView?.mj_insetB = bottom
                self.scrollView?.mj_offsetY = self.happenOffsetY() + self.mj_h
                
            }) { (success) in
                
                self.excecute()
            }
        }
    }

}
