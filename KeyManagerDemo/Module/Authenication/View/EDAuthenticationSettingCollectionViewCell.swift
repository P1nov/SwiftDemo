//
//  EDAuthenticationSettingCollectionViewCell.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/12.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class EDAuthenticationSettingCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel : UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15.0)
        
        return label
    }()
    
    lazy var authenticaitionSwitch: UISwitch = {
        
        let switch1 = UISwitch.init()
        switch1.isOn = false
        if #available(iOS 13.0, *) {
            switch1.onTintColor = .tertiarySystemFill
        } else {
            // Fallback on earlier versions
            switch1.onTintColor = .systemTeal
        }
        
        return switch1
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(authenticaitionSwitch)
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20.0)
        }
        
        authenticaitionSwitch.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20.0)
            make.height.equalTo(20.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
