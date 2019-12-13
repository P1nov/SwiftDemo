//
//  EditKeyStoreController.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

enum EditType {
    case edit
    case add
}

class EditKeyStoreController: BaseCollectionViewController, EditCollectionViewLayoutDelegate, UITextViewDelegate {
    
    private var decorationBackgroundColor : Int32?
    public var keyStore : KeyStore?
    
    lazy var service: EditService = {
        
        let service : EditService = EditService.init()
        
        return service
    }()
    
    func backgroundDecorationViewColor(collectionView: UICollectionView, layout: UICollectionViewLayout, section: Int) -> UIColor {
        
        if section == 0 {
            
            guard decorationBackgroundColor != nil else {
                
                decorationBackgroundColor = 0xCCFFFF
                
                return UIColor.colorWithRGB(rgb: decorationBackgroundColor!)
            }
            
            return UIColor.colorWithRGB(rgb: decorationBackgroundColor!)
        }
        
        return .clear
    }
    
    func cornerRadiusForDecorationView(collectionView : UICollectionView, layout : UICollectionViewLayout, section : Int) -> CGFloat {
        
        return 10.0
    }
    
    
    var type : EditType = .add

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configUISet() {
        super.configUISet()
        
        collectionView.register(EditCollectionViewCell.self, forCellWithReuseIdentifier: "editCellId")
        collectionView.collectionViewLayout = EditCollectionViewLayout()
        collectionView.reloadData()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelOperate))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(doneOperate))
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        
        titleLabel.text = "添加";
        
        if type == .edit {
            
            titleLabel.text = "编辑";
        }
        
    }
    
    @objc func cancelOperate() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneOperate() {
        
        if type == .add {
            
            service.keyStore?.backgroundColor = decorationBackgroundColor
            service.keyStore?.time = Int(Date.init().timeIntervalSince1970)
            service.editKeyStoreByAdding(keyStore: service.keyStore!) { (success, error) in
                
                if success {
                    
                    self.dismiss(animated: true) {
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "KeyStoreChanged"), object: nil, userInfo: nil)
                    }
                }else {
                    
                    
                }
            }
        }else {
            
            service.keyStore?.backgroundColor = decorationBackgroundColor
            service.keyStore?.time = Int(Date.init().timeIntervalSince1970)
            
            service.editKeyStoreByUpdating(keyStore: service.keyStore!) { (success, error) in
                
                if success {
                    
                    self.dismiss(animated: true) {
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "KeyStoreChanged"), object: nil, userInfo: nil)
                    }
                }else {
                    
                    
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            
            return UIEdgeInsets.init(top: 15, left: 5, bottom: 0, right: 5)
        }else {
            
            return UIEdgeInsets.init(top: 15, left: 40, bottom: 0, right: 20)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 4
        case 1:
            return 8
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            if(type == .edit) {
                
                service.keyStore = keyStore
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editCellId", for: indexPath) as! EditCollectionViewCell
            
            cell.textView.isHidden = true
            cell.textField.isHidden = false
            
            switch indexPath.row {
            case 0:
                
                cell.titleLabel.text = "标题";
                cell.textField.attributedPlaceholder = NSMutableAttributedString.init(string: "请输入标题", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)])
                cell.textField.tag = indexPath.row
                cell.textField.addTarget(self, action: #selector(editTextOnTime(textField:)), for: .editingChanged)
                
                cell.textField.text = service.keyStore?.title
                
                break
            case 1:
                
                cell.titleLabel.text = "账号";
                cell.textField.attributedPlaceholder = NSMutableAttributedString.init(string: "请输入账号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)])
                cell.textField.tag = indexPath.row
                cell.textField.addTarget(self, action: #selector(editTextOnTime(textField:)), for: .editingChanged)
                
                cell.textField.text = service.keyStore?.account
                
                break
            case 2:
                
                cell.titleLabel.text = "密码";
                cell.textField.isSecureTextEntry = true
                cell.textField.attributedPlaceholder = NSMutableAttributedString.init(string: "请输入密码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)])
                cell.textField.tag = indexPath.row
                cell.textField.addTarget(self, action: #selector(editTextOnTime(textField:)), for: .editingChanged)
                
                cell.textField.text = service.keyStore?.password
                
                break
                
            case 3:
                
                cell.titleLabel.text = "描述";
                cell.textView.isHidden = false
                cell.textField.isHidden = true
                cell.textView.delegate = self
                
                cell.textView.text = service.keyStore?.desc
                
                break
            default:
                break
            }
            
            cell.textField.textColor = .white
            cell.textView.textColor = .white
            
            return cell
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
            
            cell.contentView.clipsToBounds = true
            cell.contentView.layer.cornerRadius = 15.0
            cell.contentView.backgroundColor = UIColor.colorWithRGB(rgb: selectColors[indexPath.row])
            
            return cell
        }
    }
    
    @objc private func editTextOnTime(textField : UITextField) {
        
        switch textField.tag {
            
            case 0:
                service.keyStore?.title = textField.text
                break
            case 1:
                service.keyStore?.account = textField.text
                break
            case 2:
                service.keyStore?.password = textField.text
                break
            default:
                break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.elementsEqual("\n") {
            
            if textView.canResignFirstResponder {
                
                textView.resignFirstResponder()
            }
        }
        
        service.keyStore?.desc = textView.text
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSize.init(width: 360.0, height: 110)
        }else {
            
            return CGSize.init(width: 30.0, height: 30.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.decorationBackgroundColor = selectColors[indexPath.row]
                
                collectionView.reloadData()
                
            }, completion: nil)
        }
    }
    
    
}
