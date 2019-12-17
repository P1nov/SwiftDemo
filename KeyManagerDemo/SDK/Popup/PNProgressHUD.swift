//
//  PNProgressHUD.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/17.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

typealias PNProgressHUDCompletionBlock = () -> ()

let PNDefaultPadding : CGFloat = 4.0
let PNDefaultLabelFontSize = 16.0
let PNDefaultDetailsLabelFontSize = 12.0

let PNProgressMaxOffset : CGFloat = 1000000.0

@available(iOS 9.0, *)
@objc protocol PNProgressHUDDelegate {
    
    @objc optional
    func wasHidden(hud : PNProgressHUD);
}

@available(iOS 9.0, *)
class PNProgressHUD: UIView {
    
    weak var delegate : PNProgressHUDDelegate?
    var completionBlock : PNProgressHUDCompletionBlock?
    
    var graceTime : TimeInterval? = 2.0
    var minShowTime : TimeInterval? = 1.5
    
    var removeFromSuperViewOnHide : Bool? = false
    
    var mode : PNProgressHUDMode? {
        
        get {
            
            return _mode!
        }
        set(newValue) {
            
            _mode = newValue
            
            self.updateIndicators()
        }
    }
    var _mode : PNProgressHUDMode?
    
    var animationType : PNProgressHUDAnimation? = .zoomOut
    var contentColor : UIColor? {
        
        get {
            
            return _contentColor
        }
        set(contentColor) {
            
            guard let oldColor = _contentColor, let newColor = contentColor else {
                
                return
            }
            
            if !oldColor.isEqual(newColor) {
                
                _contentColor = newColor
                
                self.updateViews(forColor: _contentColor)
            }
            
        }
    }
    var _contentColor : UIColor?
    
    var offset : CGPoint? {
        
        get {
            
            return _offset
        }
        set(offset) {
            
            guard let oldOffset = _offset, let newOffset = offset else {
                
                return
            }
            
            if !oldOffset.equalTo(newOffset) {
                
                _offset = newOffset
                
                self.setNeedsUpdateConstraints()
            }
        }
    }
    var _offset : CGPoint?
    
    var margin : CGFloat? {
        
        get {
            
            return _margin
        }
        set(margin) {
            
            guard let oldMargin = _margin, let newMargin = margin else {
                
                return
            }
            
            if oldMargin != newMargin {
                
                _margin = newMargin
                
                self.setNeedsUpdateConstraints()
            }
        }
    }
    var _margin : CGFloat?
    
    var minSize : CGSize? {
        
        get {
            
            return _minSize
        }
        set(minSize) {
            
            guard let old = _minSize, let new = minSize else {
                
                return
            }
            
            if !old.equalTo(new) {
                
                _minSize = new
                
                self.setNeedsUpdateConstraints()
            }
        }
    }
    var _minSize : CGSize?
    
    var square : Bool? {
        
        get {
            
            return _square
        }
        set(square) {
            
            guard let oldSquare = _square, let newSquare = square else {
                
                return
            }
            
            if oldSquare != newSquare {
                
                _square = newSquare
                
                self.setNeedsUpdateConstraints()
            }
        }
    }
    var _square : Bool?
    
    var defaultMotionEffectsEnabled : Bool? {
        
        get {
            
            return _defaultMotionEffectsEnabled
        }
        
        set(enabled) {
            
            guard let old = _defaultMotionEffectsEnabled, let new = enabled else {
                
                return
            }
            
            if old != new {
                
                _defaultMotionEffectsEnabled = new
                
                self.updateBezelMotionEffects()
            }
        }
    }
    var _defaultMotionEffectsEnabled : Bool?
    
    var progress : CGFloat? {
        
        get {
            
            return _progress
        }
        
        set(progress) {
            
            guard let oldProgress = _progress, let newProgress = progress else {
                
                return
            }
            
            if oldProgress != newProgress {
                
                _progress = newProgress
            }
        }
    }
    var _progress : CGFloat? {
        
        willSet(progress) {
            
            
        }
        
        didSet(progress) {
            
            let indicator = self.indicator
            
            indicator?.setValue(self.progress, forKey: "progress")
        }
    }
    
    var progressObject : Progress? {
        
        get {
            
            return _progressObject
        }
        set(object) {
            
            guard let oldProgress = _progressObject, let newProgress = object else {
                
                return
            }
            
            if oldProgress != newProgress {
                
                _progressObject = newProgress
                
                self.setPNProgressDisplayLink(enabled: true)
            }
        }
        
    }
    var _progressObject : Progress?
    
    var bezelView : PNBackgroundView?
    var backgroundView : PNBackgroundView?
    
    var customView : UIView? {
        
        get {
            
            return _customView!
        }
        set(customView) {
            
            if _customView != customView {
                
                if self.mode == .customView {
                    
                    self.updateIndicators()
                }
            }
        }
    }
    var _customView : UIView?
    
    var label : UILabel?
    var detailsLabel : UILabel?
    var button : UIButton?
    
    private var useAnimation : Bool? = false
    private var hasFinished : Bool? = true
    private var indicator : UIView?
    private var showStarted : Date?
    private var paddingConstraints : [NSLayoutConstraint]?
    private var bezelConstraints : [NSLayoutConstraint]?
    private var topSpacer : UIView?
    private var bottomSpacer : UIView?
    private var bezelMotionEffects : UIMotionEffectGroup?
    private var graceTimer : Timer?
    private var minShowTimer : Timer?
    private var hideDelayTimer : Timer?
    private var progressObjectDisplayLink : CADisplayLink? {
        
        get {
            
            return _progressObjectDisplayLink
        }
        set(displayLink) {
            
            guard let oldLink = _progressObjectDisplayLink, let newLink = displayLink else {
                
                return
            }
            
            if oldLink != newLink {
                
                _progressObjectDisplayLink?.invalidate()
                
                _progressObjectDisplayLink = newLink
                
                _progressObjectDisplayLink?.add(to: RunLoop.main, forMode: .default)
            }
        }
    }
    private var _progressObjectDisplayLink : CADisplayLink?
    
    class func show(to view : UIView, animated : Bool) -> PNProgressHUD {

        let hud = self.init(withView: view)
        hud.removeFromSuperViewOnHide = true
        view.addSubview(hud)
        hud.show(animated: true)
        
        return hud
    }

    class func hide(for view : UIView, animated : Bool) -> Bool {
        
        guard let hud = self.hud(forView: view) else {
            
            return false
        }
        
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: animated)
        
        return true
    }

    class func hud(forView view : UIView) -> PNProgressHUD? {

        let subViews = view.subviews.reversed()
        
        for subView in subViews {
            
            if subView.isKind(of: self) {
                
                let hud : PNProgressHUD = subView as! PNProgressHUD
                
                if !hud.hasFinished! {
                    
                    return hud
                }
            }
        }
        
        return nil
    }
    
    func hide(animated : Bool) {
        
        
    }
    
    func hide(animated : Bool, afterDelay delay : TimeInterval) {
        
        self.hideDelayTimer?.invalidate()
        
        let timer = Timer.init(timeInterval: delay, target: self, selector: #selector(handleHideTimer(timer:)), userInfo: animated, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        
        self.hideDelayTimer = timer
    }
    
    func show(animated : Bool) {
        
        assert(Thread.isMainThread, "PNProgressHUD needs to be accessed on the main thread.")
        
        self.minShowTimer?.invalidate()
        
        self.useAnimation = animated
        self.hasFinished = false
        
        if Double(self.graceTime!) > 0.0 {
            
            let timer = Timer.init(timeInterval: self.graceTime!, target: self, selector: #selector(handleGraceTimer(timer:)), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: .common)
            
            self.graceTimer = timer
        }else {
            
            self.show(usingAnimation: self.useAnimation!)
        }
    }
    
    private func show(usingAnimation animation : Bool) {
        
        self.bezelView?.layer.removeAllAnimations()
        self.backgroundView?.layer.removeAllAnimations()
        
        self.hideDelayTimer?.invalidate()
        
        self.showStarted = Date()
        self.alpha = 1.0
        
        self.setPNProgressDisplayLink(enabled: true)
        
        self.updateBezelMotionEffects()
        
        if animation {
            
            self.animate(in: true, type: self.animationType!, completion: nil)
        }else {
            
            self.bezelView?.alpha = 1.0
            self.backgroundView?.alpha = 1.0
        }
    }
    
    private func hide(useAnimation animated : Bool) {
        
        self.hideDelayTimer?.invalidate()
        
        if animated && self.showStarted != nil {
            
            self.animate(in: false, type: self.animationType!) { (completed) in
                
                self.done()
            }
        }else {
            
            self.showStarted = nil
            self.bezelView?.alpha = 0.0
            self.backgroundView?.alpha = 1.0
            self.done()
        }

    }
    
    private func animate(in animatedIn : Bool, type : PNProgressHUDAnimation, completion : ((_ finished : Bool) -> Void)?) {
        
        var animation : PNProgressHUDAnimation = type
        
        if animation == .zoom {
            
            animation = animatedIn ? .zoomIn : .zoomOut
        }
        
        let small = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        let large = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        
        let bezelView = self.bezelView
        
        if animatedIn && bezelView?.alpha == 0.0 && animation == .zoomIn {
            
            bezelView?.transform = small
        }else {
            
            bezelView?.transform = large
        }
        
        let animations = {
            
            if animatedIn {
                
                bezelView?.transform = .identity
            }else if !animatedIn && animation == .zoomIn {
                
                bezelView?.transform = large
            }else if !animatedIn && animation == .zoomOut {
                
                bezelView?.transform = small
            }
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .beginFromCurrentState, animations: animations, completion: completion)
        
    }
    
    private func updateBezelMotionEffects() {
        
        let bezelView = self.bezelView
        let bezelMotionEffects = self.bezelMotionEffects
        
        if self.defaultMotionEffectsEnabled! && bezelMotionEffects == nil {
            
            let effectOffset = 10.0
            
            let effectX = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            effectX.maximumRelativeValue = effectOffset
            effectX.minimumRelativeValue = -effectOffset
            
            let effectY = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            effectY.maximumRelativeValue = effectOffset
            effectY.minimumRelativeValue = -effectOffset
            
            let effectGroup = UIMotionEffectGroup.init()
            effectGroup.motionEffects = [effectX, effectY]
            
            self.bezelMotionEffects = effectGroup
            bezelView?.addMotionEffect(effectGroup)
            
        }else if bezelMotionEffects != nil {
            
            self.bezelMotionEffects = nil
            bezelView?.removeMotionEffect(bezelMotionEffects!)
        }
    }
    
    private func setPNProgressDisplayLink(enabled : Bool) {
        
        if enabled && self.progressObject != nil {
            
            if self.progressObjectDisplayLink == nil {
                
                self.progressObjectDisplayLink = CADisplayLink.init(target: self, selector: #selector(updateProgressFromProgressObject))
            }
        }else {
            
            self.progressObjectDisplayLink = nil
        }
    }
    
    @objc private func updateProgressFromProgressObject() {
        
        self.progress = CGFloat(self.progressObject!.fractionCompleted)
    }
    
    @objc private func handleGraceTimer(timer : Timer) {
        
        if !self.hasFinished! {
            
            self.show(usingAnimation: self.useAnimation!)
        }
    }
    
    @objc private func handleHideTimer(timer : Timer) {
        
        self.hide(animated: false)
    }
    
    @objc private func hanleMinShowTime(timer : Timer) {
        
        self.hide(useAnimation: self.useAnimation!)
    }
    
    private func commonInit() {
        
        animationType = .fade
        mode = .indeterminate
        margin = 20.0
        defaultMotionEffectsEnabled = false
        contentColor = UIColor.init(white: 0.0, alpha: 0.7)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.alpha = 0.0
        self.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        self.layer.allowsGroupOpacity = false
        
        self.setupViews()
        self.updateIndicators()
    }
    
    private func done() {
        
        self.setPNProgressDisplayLink(enabled: false)
        
        if self.hasFinished! {
            
            self.alpha = 0.0
            
            if self.removeFromSuperViewOnHide! {
                
                self.removeFromSuperview()
            }
        }
        
        let completionBlock : PNProgressHUDCompletionBlock? = self.completionBlock
        
        if completionBlock != nil {
            
            completionBlock!()
        }
        
        guard let delegate : PNProgressHUDDelegate = self.delegate else {
            
            return
        }
        
        delegate.wasHidden?(hud: self)
        
    }
    
    private func setupViews() {
        
        let defaultColor = self.contentColor
        
        let background = PNBackgroundView.init(frame: self.bounds)
        background.style = .solidColor
        background.backgroundColor = .clear
        background.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        background.alpha = 0.0
        self.addSubview(background)
        backgroundView = background
        
        let bezel = PNBackgroundView()
        bezel.translatesAutoresizingMaskIntoConstraints = false
        bezel.layer.cornerRadius = 5.0
        bezel.alpha = 0.0
        self.addSubview(bezel)
        bezelView = bezel
        
        let label1 = UILabel()
        label1.adjustsFontSizeToFitWidth = false;
        label1.textAlignment = .center;
        label1.textColor = defaultColor;
        label1.font = UIFont.boldSystemFont(ofSize: CGFloat(PNDefaultLabelFontSize))
        label1.isOpaque = false
        label1.backgroundColor = .clear
        self.addSubview(label1)
        label = label1
        
        let details = UILabel()
        details.adjustsFontSizeToFitWidth = false
        details.textAlignment = .center
        details.textColor = defaultColor
        details.numberOfLines = 0
        details.font = UIFont.boldSystemFont(ofSize: CGFloat(PNDefaultDetailsLabelFontSize))
        details.isOpaque = false
        details.backgroundColor = .clear
        self.addSubview(details)
        detailsLabel = details
        
        let btn = PNProgressHUDRoundedButton.init(type: .custom)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(PNDefaultDetailsLabelFontSize))
        btn.setTitleColor(defaultColor, for: .normal)
        button = btn
        
        for view in [label1, details, btn] {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: .horizontal)
            view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: .vertical)
            bezelView?.addSubview(view)
        }
        
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.isHidden = true
        bezelView?.addSubview(topView)
        topSpacer = topView
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.isHidden = true
        bezelView?.addSubview(bottomView)
        bottomSpacer = bottomView
        
    }
    
    private func updateIndicators() {
        
        var indicator = self.indicator
        
        let isActivityIndicator = indicator?.isKind(of: UIActivityIndicatorView.self) ?? false
        let isRoundIndicator = indicator?.isKind(of: PNRoundProgressView.self) ?? false
        
        let mode : PNProgressHUDMode = self.mode ?? .text
        
        if mode == .indeterminate {
            
            if !isActivityIndicator {
                
                indicator?.removeFromSuperview()
                indicator = UIActivityIndicatorView.init(style: .whiteLarge)
                (indicator as! UIActivityIndicatorView).startAnimating()
                
                self.bezelView?.addSubview(indicator!)
            }
        }else if mode == .determinateHorizontalBar {
            
            indicator?.removeFromSuperview()
            indicator = PNBarProgressView.init()
            self.bezelView?.addSubview(indicator!)
            
        }else if mode == .determinate || mode == .annularDeterminate {
            
            if !isRoundIndicator {
                
                indicator?.removeFromSuperview()
                indicator = PNRoundProgressView.init()
                self.bezelView?.addSubview(indicator!)
            }
            
            if mode == .annularDeterminate {
                
                (indicator as! PNRoundProgressView).annular = true
            }
        }else if mode == .customView && self.customView != indicator {
            
            indicator?.removeFromSuperview()
            indicator = self.customView
            self.bezelView?.addSubview(indicator!)
            
        }else if mode == .text {
            
            indicator?.removeFromSuperview()
            indicator = nil
        }
        
        indicator?.translatesAutoresizingMaskIntoConstraints = false
        self.indicator = indicator
        
        if indicator!.isKind(of: PNBarProgressView.self) || indicator!.isKind(of: PNRoundProgressView.self) || indicator!.isKind(of: PNProgressHUD.self) {
            
            indicator?.setValue(self.progress, forKey: "progress")
        }
        
        indicator?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: .horizontal)
        indicator?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: .vertical)
        
//        self.updateViewsForColor:
    }
    
    private func updateViews(forColor color : UIColor?) {
        
        guard let _ = color else {
            
            return
        }
        
        self.label?.textColor = color
        self.detailsLabel?.textColor = color
        self.button?.setTitleColor(color, for: .normal)
        
        let indicator = self.indicator
        
        if indicator!.isKind(of: UIActivityIndicatorView.self) {
            
            var appearance : UIActivityIndicatorView? = nil
            
            appearance = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [PNProgressHUD.self])
            
            if appearance?.color == nil {
                
                (indicator as! UIActivityIndicatorView).color = color
            }
            
        }else if indicator!.isKind(of: PNRoundProgressView.self) {
            
            var appearance : PNRoundProgressView? = nil
            
            appearance = PNRoundProgressView.appearance(whenContainedInInstancesOf: [PNProgressHUD.self])
            
            if appearance?.progressTintColor == nil {
                
                (indicator as! PNRoundProgressView).progressTintColor = color
            }
            
            if appearance?.backgroundTintColor == nil {
                
                (indicator as! PNRoundProgressView).backgroundTintColor = color?.withAlphaComponent(0.1)
            }
        }else if indicator!.isKind(of: PNBarProgressView.self) {
            
            var appearance : PNBarProgressView? = nil
            
            appearance = PNBarProgressView.appearance(whenContainedInInstancesOf: [PNProgressHUD.self])
            
            if appearance?.progressColor == nil {
                
                (indicator as! PNBarProgressView).progressColor = color
            }
            
            if appearance?.lineColor == nil {
                
                (indicator as! PNBarProgressView).lineColor = color
            }
        }else {
            
            indicator?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }

    required init(withView view : UIView) {
        
        super.init(frame: view.bounds)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
//        self.commonInit()
    }
    
    override func updateConstraints() {
        
        let bezelView = self.bezelView
        let topSpacer = self.topSpacer
        let bottomSpacer = self.bottomSpacer
        let margin = self.margin
        let bezelConstraints : NSMutableArray = NSMutableArray.init()
        let metrics : [String : Any] = ["margin" : margin as Any]
        
        var subViews = Array.init(arrayLiteral: self.topSpacer, self.label, self.detailsLabel, self.button, self.bottomSpacer)
        
        if self.indicator != nil {
            
            subViews.insert(self.indicator, at: 1)
        }
        
        self.removeConstraints(self.constraints)
        
        topSpacer?.removeConstraints(topSpacer?.constraints ?? [])
        bottomSpacer?.removeConstraints(bottomSpacer?.constraints ?? [])
        
        if self.bezelConstraints != nil {
            
            bezelView?.removeConstraints(self.bezelConstraints!)
            self.bezelConstraints = nil
        }
        
        let offset : CGPoint = self.offset ?? .zero
        
        var centeringConstraints : Array = Array<NSLayoutConstraint>.init()
        centeringConstraints.append(NSLayoutConstraint.init(item: bezelView as Any, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: offset.x))
        centeringConstraints.append(NSLayoutConstraint.init(item: bezelView as Any, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: offset.y))
        self.apply(priority: UILayoutPriority.init(rawValue: 998.0), to: centeringConstraints)
        self.addConstraints(centeringConstraints)
        
        let sideConstraints : NSMutableArray = NSMutableArray.init()
        sideConstraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "|-(>=margin)-[bezelView]-(>=margin)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: ["bezelView": bezelView as Any]))
        sideConstraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=margin)-[bezel]-(>=margin)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: ["bezelView": bezelView as Any]))
        self.apply(priority: UILayoutPriority.init(rawValue: 999.0), to: sideConstraints as! [NSLayoutConstraint])
        self.addConstraints(sideConstraints as! [NSLayoutConstraint])
        
        let minimumSize = self.minSize ?? .zero
        
        if minimumSize.equalTo(.zero) {
            
            var minSizeConstraints : [NSLayoutConstraint] = []
            minSizeConstraints.append(NSLayoutConstraint.init(item: bezelView as Any, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: minimumSize.width))
            minSizeConstraints.append(NSLayoutConstraint.init(item: bezelView as Any, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: minimumSize.height))
            self.apply(priority: UILayoutPriority.init(rawValue: 997.0), to: minSizeConstraints)
            bezelConstraints.addObjects(from: minSizeConstraints)
        }
        
        if self.square! {
            
            let square = NSLayoutConstraint.init(item: bezelView as Any, attribute: .height, relatedBy: .equal, toItem: bezelView, attribute: .width, multiplier: 1.0, constant: 0)
            
            bezelConstraints.add(square)
        }
        
        topSpacer?.addConstraint(NSLayoutConstraint.init(item: topSpacer as Any, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: margin!))
        bottomSpacer?.addConstraint(NSLayoutConstraint.init(item: bottomSpacer as Any, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: margin!))
        bezelConstraints.add(NSLayoutConstraint.init(item: topSpacer as Any, attribute: .height, relatedBy: .equal, toItem: bottomSpacer, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        var paddingConstraints : [NSLayoutConstraint] = []
        
        subViews.enumerated().map { (index, view) -> Void in
            
            bezelConstraints.add(NSLayoutConstraint.init(item: view as Any, attribute: .centerX, relatedBy: .equal, toItem: bezelView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            bezelConstraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "|-(>=margin)-[view]-(>=margin)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: ["view": view as Any]))
            
            if index == 0 {
                
                bezelConstraints.add(NSLayoutConstraint.init(item: view as Any, attribute: .top, relatedBy: .equal, toItem: bezelView, attribute: .top, multiplier: 1.0, constant: 0.0))
            }else if index == subViews.count - 1 {
                
                bezelConstraints.add(NSLayoutConstraint.init(item: view as Any, attribute: .bottom, relatedBy: .equal, toItem: bezelView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            }
            
            if index > 0 {
                
                let padding : NSLayoutConstraint = NSLayoutConstraint.init(item: view as Any, attribute: .top, relatedBy: .equal, toItem: subViews[index - 1] as Any, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                
                bezelConstraints.add(padding)
                paddingConstraints.append(padding)
            }
        }
        
        bezelView?.addConstraints(bezelConstraints as! [NSLayoutConstraint])
        self.paddingConstraints = paddingConstraints
        
        self.updatePaddingConstraints()
        
        super.updateConstraints()
        
    }
    
    private func updatePaddingConstraints() {
        
        let hasVisibleAncestors : ObjCBool = false
        
        self.paddingConstraints?.enumerated().map({ (index, padding) -> Void in
            
            guard let firstView = padding.firstItem, let secondView = padding.secondItem else {
                
                return
            }
            
            let firstVisible = !firstView.isHidden && firstView.intrinsicContentSize!.equalTo(.zero)
            let secondVisible = !secondView.isHidden && secondView.intrinsicContentSize!.equalTo(.zero)
            
            padding.constant = (firstVisible && (secondVisible || hasVisibleAncestors.boolValue)) ? PNDefaultPadding : 0.0
            
        })
    }
    
    private func apply(priority : UILayoutPriority, to constraints : [NSLayoutConstraint]) {
        
        for constraint in constraints {
            
            constraint.priority = priority
        }
    }
}

extension UIView {
    
    enum PNProgressHUDMode {
        case indeterminate
        case determinate
        case determinateHorizontalBar
        case annularDeterminate
        case customView
        case text
    }
    
    enum PNProgressHUDAnimation {
        case fade
        case zoom
        case zoomOut
        case zoomIn
    }
    
    enum PNProgressHUDBackgroundStyle {
        case solidColor
        case blur
    }
}

class PNRoundProgressView : UIView {
    
    var progress : CGFloat?
    var progressTintColor : UIColor? = .white
    var backgroundTintColor : UIColor? = UIColor.colorWithRGB(rgb: 0x999999)
    var annular : Bool? = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.isOpaque = false
        self.progress = 0.0
        self.annular = false;
        self.progressTintColor = UIColor.init(white: 1.0, alpha: 1.0)
        self.backgroundTintColor = UIColor.init(white: 1.0, alpha: 0.1)
    }
    
    init() {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
        
        self.backgroundColor = .clear
        self.isOpaque = false
        self.progress = 0.0
        self.annular = false;
        self.progressTintColor = UIColor.init(white: 1.0, alpha: 1.0)
        self.backgroundTintColor = UIColor.init(white: 1.0, alpha: 0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
}

class PNBarProgressView : UIView {
    
    var progress : CGFloat?
    var lineColor : UIColor? = .white
    var progressRemainingColor : UIColor? = UIColor.colorWithRGB(rgb: 0x999999)
    var progressColor : UIColor? = UIColor.colorWithRGB(rgb: 0x999999)
}

class PNBackgroundView : UIView {
    
    var style : PNProgressHUDBackgroundStyle? = .solidColor
    var blurEffectStyle : UIBlurEffect.Style? = .light
    var color : UIColor? = .white
}

class PNProgressHUDRoundedButton : UIButton {
    
    
}
