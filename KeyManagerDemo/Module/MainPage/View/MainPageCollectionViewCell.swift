//
//  MainPageCollectionViewCell.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit
import SnapKit

class MainPageCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        
        return titleLabel
    }()
    
    lazy var editButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("编辑", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        return button
    }()
    
    lazy var accountTextField: UITextView = {
        
        let textField = UITextView()
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5.0
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.isEditable = false
        textField.font = UIFont.systemFont(ofSize: 16.0)
        
        return textField
    }()
    
    lazy var passwordTextField: UIButton = {
        
        let textField = UIButton()
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5.0
        textField.setTitleColor(.black, for: .normal)
        textField.backgroundColor = .white
        textField.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        
        return textField
    }()
    
    lazy var descTextView: UITextView = {
        
        let descTextView = UITextView()
        descTextView.clipsToBounds = true
        descTextView.layer.cornerRadius = 5.0
        descTextView.textColor = .black
        descTextView.backgroundColor = .white
        descTextView.isEditable = false
        
        return descTextView
    }()

    var keyStore : KeyStore {
        
        set(newValue) {
            
            key = newValue
            
            titleLabel.text = newValue.title
            accountTextField.text = newValue.account
            passwordTextField.setTitle("******", for: .normal)
            descTextView.text = newValue.desc
            
            contentView.backgroundColor = UIColor.colorWithRGB(rgb: newValue.backgroundColor ?? 0xFFFFFF)
        }
        
        get {
            
            return key ?? KeyStore()
        }
    }
    
    private var key : KeyStore?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15.0
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(accountTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(descTextView)
        
        editButton.snp.makeConstraints { (make) in
        
            make.right.equalToSuperview().offset(-15.0)
            make.top.equalToSuperview().offset(15.0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview().offset(15.0)
            make.top.equalToSuperview().offset(15.0)
            make.right.lessThanOrEqualTo(editButton.snp_left)
            make.height.equalTo(20.0) 
        }
        
        accountTextField.snp.makeConstraints { (make) in
            
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(15.0)
            make.width.equalTo(160.0)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            
            make.top.equalTo(accountTextField)
            make.left.equalTo(accountTextField.snp_right).offset(5.0)
//            make.right.lessThanOrEqualToSuperview().offset(-7.0)
            make.height.equalTo(accountTextField)
            make.right.greaterThanOrEqualToSuperview().offset(-15.0)
        }
        
        descTextView.snp.makeConstraints { (make) in
            
            make.left.equalTo(accountTextField)
            make.top.equalTo(accountTextField.snp_bottom).offset(15.0)
            make.width.equalTo(contentView).dividedBy(1.1)
            make.height.equalTo(120.0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
