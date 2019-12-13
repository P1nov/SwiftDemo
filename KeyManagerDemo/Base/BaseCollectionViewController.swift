//
//  BaseCollectioViewController.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class BaseCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var layout : UICollectionViewLayout?
    
    lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = .black
        
        return titleLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 100.0), collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUISet() {
        super.configUISet()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerViewId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerViewId")
        
        collectionView.backgroundColor = .white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView.isEqual(self.collectionView) {
            
            if indexPath.section == 0 {
                
                if kind == UICollectionView.elementKindSectionHeader {
                    
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewId", for: indexPath)
                    headerView.backgroundColor = .white
                    
                    titleLabel.removeFromSuperview()
                    
                    headerView.addSubview(titleLabel)
                    
                    titleLabel.snp.makeConstraints { (make) in
                        
                        make.centerY.equalToSuperview()
                        make.left.equalToSuperview().offset(20.0)
                    }
                    
                    return headerView
                }else {
                    
                    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerViewId", for: indexPath)
                }
            }else {
                
                if kind == UICollectionView.elementKindSectionHeader {
                    
                    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewId", for: indexPath)
                }else {
                    
                    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerViewId", for: indexPath)
                }
            }
        }else {
            
            return UICollectionReusableView.init(frame: .zero)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView.isEqual(self.collectionView) {
            
            if section == 0 {
                
                return .init(width: self.collectionView.frame.width, height: 70.0)
            }else {
                
                return .zero
            }
        }else {
            
            return .zero
        }
         
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.isEqual(self.collectionView) {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        }else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        }
        
        
    }

}
