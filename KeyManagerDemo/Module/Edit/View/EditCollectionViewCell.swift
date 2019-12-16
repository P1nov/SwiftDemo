//
//  EditCollectionViewCell.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class EditCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    lazy var textField: UITextField = {
        
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5.0
        textField.returnKeyType = .done
        textField.delegate = self
        textField.isSecureTextEntry = false
        textField.textColor = UIColor.colorWithRGB(rgb: 0x333333)
        
        return textField
    }()
    
    lazy var textView: UITextView = {
        
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 5.0
        textView.returnKeyType = UIReturnKeyType.done
        textView.textColor = UIColor.colorWithRGB(rgb: 0x333333)
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(textView)
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(15.0)
        }
        
        textField.snp.makeConstraints { (make) in
            
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(15.0)
            make.width.equalTo(contentView.bounds.width - 15.0)
            make.height.equalTo(50.0)
        }
        
        textView.snp.makeConstraints { (make) in
            
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(15.0)
            make.width.equalTo(textField)
            make.height.equalTo(50.0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.canResignFirstResponder {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
