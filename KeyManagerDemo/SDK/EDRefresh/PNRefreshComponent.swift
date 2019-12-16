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
    
    var scrollViewOriginalInset: UIEdgeInsets?
    
    var autoChangeAlpha: Bool? {
        
        get {
            
            return automaticallyChangeAlpha
        }
        set(newValue) {
            
            if isRefreshing {
                
                return
            }
            
            if newValue! {
                
                alpha = pullingPercent!
            }
            
            automaticallyChangeAlpha = newValue
        }
    }
    
    var scrollView: UIScrollView?
    
    var isRefreshing : Bool {
        
        return state == PNRefreshState.loading || state == PNRefreshState.willLoad
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var refreshingBlock : PNRefreshComponentAction!
    
    weak var refreshingTarget : AnyObject?
    var refreshAction : Selector?
    
    var begingRefreshingCompletionBlock : PNRefreshComponentAction!
    var endRefreshingAnimationBeginAction : PNRefreshComponentAction!
    var endRefreshingCompletionBlock : PNRefreshComponentAction!
    
    func setState(newState : PNRefreshState) {
        
        state = newState
        
        DispatchQueue.main.async {
            
            self.setNeedsLayout()
        }
    }
    
    var state : PNRefreshState?

    var _pullingPercent : CGFloat? {
        
        set(newValue) {
            
            pullingPercent = newValue
            
            if isRefreshing {
                
                return
            }
            
            if automaticallyChangeAlpha! {
                
                alpha = newValue!
            }
        }
        
        get {
            
            return pullingPercent
        }
    }
    
    var pullingPercent : CGFloat?
    
    var automaticallyChangeAlpha: Bool? = false
    
    func setRefreshing(target : AnyObject?, action : Selector?) {
        
        self.refreshingTarget = target;
        self.refreshAction = action;
    }
    
    func executeRefreshingCallback() {
        
        DispatchQueue.main.async {
            
            self.excecute()
        }
    }
    
    func excecute() {
        
        if refreshingBlock != nil {
            
            refreshingBlock()
        }
        
        if self.refreshingTarget?.responds(to: self.refreshAction) != nil {
            
            refreshingTarget!.perform(refreshAction, with: self)
        }
        
        if begingRefreshingCompletionBlock != nil {
            
            begingRefreshingCompletionBlock()
        }
        
    }
    
    func begingRefreshing() {
        
        
    }
    
    func begingRefreshing(CompletionBlock : PNRefreshComponentAction?) {
        
        self.begingRefreshingCompletionBlock = CompletionBlock
        
        self.begingRefreshing()
    }
    
    func endRefreshing() {
        
        
    }
    
    func endRefreshing(CompletionBlock : PNRefreshComponentAction?) {
        
        self.endRefreshingCompletionBlock = CompletionBlock;
        
        self.endRefreshing()
    }
    
    func prepare() {
        
        autoresizingMask = .flexibleWidth
        backgroundColor = .clear
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil && newSuperview!.isKind(of: UIScrollView.self) {
            
            self.removeObservers()
            
            if newSuperview != nil {
                
                scrollView = (newSuperview as! UIScrollView)
                
                self.mj_w = scrollView!.mj_w
                self.mj_x = scrollView!.mj_insetL
                
                scrollView?.alwaysBounceVertical = true
                scrollViewOriginalInset = scrollView!.mj_inset
                
                self.addObservers()
                
                setState(newState: .idle)
            }
        }
        
    }
    
    func placeSubviews() {}
    
    override func layoutSubviews() {
        
        self.placeSubviews()
        
        super.layoutSubviews()
    }
    
    func scrollViewContentOffsetDidChange(change : NSDictionary?) {
        
        
    }
    
    func scrollViewContentSizeDidChange(change : NSDictionary?) {
        
        
    }
    
    func scrollViewPanStateDidChange(change : NSDictionary?) {
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !self.isUserInteractionEnabled {
            return
        }
        
        if (keyPath?.elementsEqual("contentSize"))! {
            
            self.scrollViewContentSizeDidChange(change: change as NSDictionary?)
        }
        
        if isHidden {
            
            return
        }
        
        if keyPath!.elementsEqual("contentOffset") {
            
            self.scrollViewContentOffsetDidChange(change: change as NSDictionary?)
        }
        
    }
    
    func removeObservers() {
        
        self.superview?.removeObserver(self, forKeyPath: "contentOffSet")
        self.superview?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func addObservers() {
        
        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
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
