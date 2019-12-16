//
//  PNRefreshNormalHeader.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/16.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNRefreshNormalHeader: PNRefreshHeader {

    lazy var loadingView: UIActivityIndicatorView = {
        
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        loadingView.style = .gray
        
        return loadingView
    }()
    
    lazy var arrowImageView: UIImageView = {
        
        let imageView = UIImageView.init(image: UIImage(named: "ed_down_arrow"))
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "加载中"
        titleLabel.textColor = UIColor.colorWithRGB(rgb: 0x666666)
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        return titleLabel
    }()
    
    override func placeSubviews() {
        super.placeSubviews()
        
        self.addSubview(loadingView)
        self.addSubview(titleLabel)
        self.addSubview(arrowImageView)
        
        loadingView.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalTo(self.snp_centerX).offset(-5.0)
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            
            make.center.equalTo(loadingView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp_centerX).offset(5.0)
        }
    }
    
    override func scrollViewContentOffsetDidChange(change: NSDictionary?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
    }
    
    override func scrollViewContentSizeDidChange(change: NSDictionary?) {
        super.scrollViewContentSizeDidChange(change: change)
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepare() {
        super.prepare()
        
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        titleLabel.text = "加载完成"
        
        self.perform(#selector(changeTitle), with: nil, afterDelay: 0.7)
    }
    
    @objc func changeTitle() {
        
        titleLabel.text = "下拉刷新"
    }
    
    override func begingRefreshing() {
        super.begingRefreshing()
        
    }
    
    override func setState(newState: PNRefreshComponent.PNRefreshState) {
        
        super.setState(newState: newState)
        
        let oldState = state
        
        state = newState
        
        if newState == .idle {
            
            if oldState == .loading {
                
                titleLabel.text = "松开取消刷新"
                
                UIView.animate(withDuration: PNRefreshSlowAnimationDuration, animations: {
                    
                    self.loadingView.alpha = 0.0
                }) { (completed) in
                    
                    if self.state != .idle {
                        
                        return
                    }
                    
                    self.loadingView.alpha = 1.0
                    self.loadingView.stopAnimating()
                    self.arrowImageView.isHidden = false
                }
            }else {
                
                self.loadingView.stopAnimating()
                
                self.arrowImageView.isHidden = false
                UIView.animate(withDuration: PNRefreshFastAnimationDuration) {
                    
                    self.arrowImageView.transform = .identity
                }
            }
        }else if newState == .pulling || newState == .willLoad {
            
            self.loadingView.stopAnimating()
            
            self.arrowImageView.isHidden = false
            
            titleLabel.text = "松开立即刷新"
            
            UIView.animate(withDuration: PNRefreshFastAnimationDuration) {
                
                self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: 0.0001 - CGFloat(Double.pi))
            }
            
        }else if newState == .loading {
            
            self.loadingView.alpha = 1.0
            self.loadingView.startAnimating()
            self.arrowImageView.isHidden = true
            
            titleLabel.text = "加载中..."
            
        }
    }

}
