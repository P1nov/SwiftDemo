//
//  MainPageControllerViewController.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

@objc
class MainPageControllerViewController: BaseCollectionViewController {
    
    var mainPageKeyStores : [KeyStore]? = nil
    var filterKeyStores : [KeyStore]? = nil
    
    var lonPress : Bool = false
    
    lazy var colorCollectionView : UICollectionView = {
       
        let collectionView = UICollectionView.init(frame: self.addBtn.frame.inset(by: .zero), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        
        collectionView.backgroundColor = .darkGray
        
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 20
        collectionView.frame.origin.x = self.view.bounds.size.width - 60.0
        collectionView.frame.origin.y = self.view.bounds.size.height - 40.0
        collectionView.frame.size.width = 45.0
        collectionView.frame.size.height = 45.0
        
        return collectionView
        
    }()
    
    lazy var settingAddBtn: UIButton = {
        
        let button = UIButton.init(frame: CGRect(x: self.view.bounds.size.width - 60, y: self.view.bounds.size.height - 40.0, width: 30.0, height: 30.0))
        
        button.setImage(UIImage(named: "ed_add"), for: .normal)
        button.addTarget(self, action: #selector(addKeyStore), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    lazy var settingBtn: UIButton = {
        
        let button = UIButton.init(frame: CGRect(x: self.view.bounds.size.width - 60, y: self.view.bounds.size.height - 40.0, width: 30.0, height: 30.0))
        
        button.setImage(UIImage(named: "ed_setting"), for: .normal)
        button.addTarget(self, action: #selector(goSetting), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    lazy var dimmingView : UIView = {
       
        let dimmingView = UIView.init(frame: self.view.bounds)
        dimmingView.backgroundColor = UIColor.init(white: 0.7, alpha: 0.7)
        dimmingView.isHidden = true
        
        dimmingView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissColorSelected)))
        
        return dimmingView
        
    }()
    
    override var preferredContentSize: CGSize {
        
        get {
            
            return .init(width: 100, height: 25)
        }
        
        set(newValue) {
            
            super.preferredContentSize = newValue
        }
    }
    
    lazy var addBtn: UIButton = {
        
        let button = UIButton()
        
        button.addTarget(self, action: #selector(addKeyStore), for: .touchUpInside)
//        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(named: "ed_add"), for: .normal)
        let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(filterColor(tap:)))
        tap.minimumPressDuration = 1.0
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    lazy var mainPageService: MainPageService = {
        
        let service = MainPageService()
        
        return service
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        loadData()
        
    }

    override func configUISet() {
        
        super.configUISet()
        
        titleLabel.text = "钥匙串";
        
        self.preferredContentSize = .init(width: 100, height: 100)
        
        colorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCellId")
        collectionView.register(MainPageCollectionViewCell.self, forCellWithReuseIdentifier: "mainPageCellId")

//        collectionView.pn_header = PNRefreshHeader.header(with: {
//
//            self.loadData()
//        })
        collectionView.pn_header = PNRefreshNormalHeader.header(with: self, action: #selector(loadData))
        
        self.view.addSubview(addBtn)
        
        addBtn.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().offset(-20.0)
            make.right.equalToSuperview().offset(-20.0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "KeyStoreChanged"), object: nil)
    }
    
    @objc func loadData() {
        
        mainPageService.getKeyStores { (success, error) in
            
            self.collectionView.pn_header?.endRefreshing()
            
            if success {
                
                filterKeyStores = mainPageService.mainPageKeyStores
                collectionView.reloadData()
                
            }else {
                
                print("获取数据失败")
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.isEqual(colorCollectionView) {
            
            return selectColors.count
        }
        
        return mainPageService.mainPageKeyStores?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !collectionView.isEqual(colorCollectionView) {
            
            let cell : MainPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainPageCellId", for: indexPath) as! MainPageCollectionViewCell
            
            cell.keyStore = mainPageService.mainPageKeyStores![indexPath.row]
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editKeyStore(button:)), for: .touchUpInside)
            
            cell.accountTextField.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(pasteAccount(tap:))))
            cell.passwordTextField.addTarget(self, action: #selector(pastePassword(passwordTextField:)), for: .touchUpInside)
            
            
            return cell
        }else {
            
            let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCellId", for: indexPath)
            
            cell.clipsToBounds = true
            cell.contentView.layer.cornerRadius = 15.0
            cell.contentView.backgroundColor = UIColor.colorWithRGB(rgb: selectColors[indexPath.row])
            
            return cell
        }
        
        
    }
    
    @objc private func goSetting() {
        
        self.navigationController?.pushViewController(EDAuthenticationSettingViewController(), animated: true)
    }
    
    @objc private func dismissColorSelected() {
        
        dimmingView.alpha = 1.0
        colorCollectionView.alpha = 1.0
        settingAddBtn.alpha = 1.0
        settingBtn.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.colorCollectionView.frame.origin.x = self.view.bounds.size.width - 60.0
            self.colorCollectionView.frame.origin.y = self.view.bounds.size.height - 40.0
            self.colorCollectionView.frame.size.width = 45.0
            self.colorCollectionView.frame.size.height = 45.0
            
            self.settingAddBtn.frame = self.addBtn.frame.inset(by: .zero)
            self.settingBtn.frame = self.addBtn.frame.inset(by: .zero)
            
            self.dimmingView.alpha = 0.0
            self.colorCollectionView.alpha = 0.0
            
            
            self.addBtn.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
            
        }) { (completed) in
            
            self.dimmingView.removeFromSuperview()
            self.colorCollectionView.removeFromSuperview()
            self.settingAddBtn.removeFromSuperview()
            self.settingBtn.removeFromSuperview()
            
            let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(self.filterColor(tap:)))
            tap.minimumPressDuration = 2.0
            self.addBtn.addGestureRecognizer(tap)
            
            
        }
    }
    
    @objc func addKeyStore() {
        
        let editNav = UINavigationController.init(rootViewController: EditKeyStoreController.init())
        
        self.present(editNav, animated: true, completion: nil)
    }
    
    @objc func editKeyStore(button : UIButton) {
        
        let controller = EditKeyStoreController.init()
        controller.type = .edit
        controller.keyStore = mainPageService.mainPageKeyStores![button.tag]
        
        let editNav = UINavigationController.init(rootViewController: controller)
        
        self.present(editNav, animated: true, completion: nil)
    }
    
    @objc private func filterColor(tap : UILongPressGestureRecognizer) {
        
        switch tap.state {
            
        case .began:
            
            self.view.addSubview(dimmingView)
            self.view.addSubview(colorCollectionView)
            self.view.addSubview(settingAddBtn)
            self.view.addSubview(settingBtn)
            
            dimmingView.isHidden = false
            dimmingView.alpha = 0.0
            
            settingAddBtn.isHidden = false
            settingAddBtn.alpha = 0.0
            
            settingBtn.isHidden = false
            settingBtn.alpha = 0.0
            
            colorCollectionView.isHidden = false
            colorCollectionView.alpha = 0.0
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.dimmingView.alpha = 1.0
                self.colorCollectionView.alpha = 1.0
                self.settingAddBtn.alpha = 1.0
                self.settingBtn.alpha = 1.0
                
                self.colorCollectionView.frame = self.addBtn.frame.inset(by: UIEdgeInsets.init(top: -450, left: 0, bottom: 150, right: 0))
                self.collectionView.frame.size.width = 255.0
                self.collectionView.frame.size.height = 45.0
                
                self.settingAddBtn.frame = self.addBtn.frame.inset(by: .init(top: 0, left: -120, bottom: 0, right: 90))
                self.settingBtn.frame = self.addBtn.frame.inset(by: .init(top: -100, left: -80, bottom: 70, right: 50))
                
                self.addBtn.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 4.0))
                
            }) { (completed) in
                
                self.view.bringSubviewToFront(self.addBtn)
                
                guard let tap = self.addBtn.gestureRecognizers?.first else {
                    
                    return
                }
                self.addBtn.removeGestureRecognizer(tap)
            }
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.isEqual(self.collectionView) {
            
            return CGSize(width: 360.0, height: Double(mainPageService.mainPageKeyStores![indexPath.row].height))
        }else {
            
            return CGSize.init(width: 30.0, height: 30.0)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView.isEqual(self.collectionView) {
            
            return .zero
        }else {
            
            return .init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 70 {
            
            self.setPageTitleByName(title: "钥匙串")
        }else {
            
            self.setPageTitleByName(title: "")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    /*
     复制密码
     */
    @objc private func pastePassword(passwordTextField : UIButton) {
        
        let pasterBoard = UIPasteboard.general
        
        pasterBoard.setValue(mainPageService.mainPageKeyStores![passwordTextField.tag].password as Any, forPasteboardType: "String")
        passwordTextField.setTitle(mainPageService.mainPageKeyStores![passwordTextField.tag].password, for: .normal)
        
        EDPopUpHUD.popUpMessage(message: "密码复制成功", in: collectionView)
        
        self.perform(#selector(securitySet(passwordTextField:)), with: passwordTextField, afterDelay: 1.0, inModes: [.common])
    }
    
    /*
     复制账号
     */
    @objc private func pasteAccount(tap : UITapGestureRecognizer) {
        
        let accountTextField : UITextView = tap.view as! UITextView
        
        let pasterBoard = UIPasteboard.general
        
        pasterBoard.setValue(accountTextField.text as Any, forPasteboardType: "String")
        
        EDPopUpHUD.popUpMessage(message: "账号复制成功", in: collectionView)
    }
    
    @objc private func securitySet(passwordTextField : UIButton) {
        
//        passwordTextField.isSecureTextEntry = true
        passwordTextField.setTitle("******", for: .normal)
    }
}
