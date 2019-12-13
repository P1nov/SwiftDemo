//
//  EDAuthenticationSettingViewController.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/12.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class EDAuthenticationSettingViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUISet() {
        super.configUISet()
        
        collectionView.register(EDAuthenticationSettingCollectionViewCell.self, forCellWithReuseIdentifier: "authenticationCellId")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: self.view.bounds.size.width, height: 50.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : EDAuthenticationSettingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "authenticationCellId", for: indexPath) as! EDAuthenticationSettingCollectionViewCell
        
        cell.titleLabel.text = "生物验证";
        cell.authenticaitionSwitch.isOn = UserDefaults.standard.bool(forKey: "authenticationIsOn")
        cell.authenticaitionSwitch.addTarget(self, action: #selector(authenticationSwitchOnOrOff(switch1:)), for: .valueChanged)
        
        return cell
    }
    
    @objc private func authenticationSwitchOnOrOff(switch1 : UISwitch) {
        
        if switch1.isOn {
            
            UserDefaults.standard.set(true, forKey: "authenticationIsOn")
            UserDefaults.standard.synchronize()
        }else {
            
            UserDefaults.standard.set(false, forKey: "authenticationIsOn")
            UserDefaults.standard.synchronize()
        }
    }
}
