//
//  EditCollectionViewLayout.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

let DecorationViewElementKind = "EditDecorationViewElementKind"

protocol EditCollectionViewLayoutDelegate : UICollectionViewDelegateFlowLayout {
    
    func backgroundDecorationViewColor(collectionView : UICollectionView, layout : UICollectionViewLayout, section : Int) -> UIColor
    
    func cornerRadiusForDecorationView(collectionView : UICollectionView, layout : UICollectionViewLayout, section : Int) -> CGFloat
}

private class EditDecorationCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes {
    
    var bgColor : UIColor = .white
    var cornerRedius : CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = super.copy(with: zone) as! EditDecorationCollectionViewLayoutAttributes
        
        copy.bgColor = self.bgColor
        copy.cornerRedius = self.cornerRedius
        
        return copy
    }
    
    override class func isEqual(_ object: Any?) -> Bool {
        
        guard (object as? EditDecorationCollectionViewLayoutAttributes) != nil else {
            
            return false
        }
        
        return super.isEqual(object)
        
    }
}

class EditDecorationView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? EditDecorationCollectionViewLayoutAttributes else {
            
            return
        }
        
        self.backgroundColor = attr.bgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = attr.cornerRedius
    }
    
}

class EditCollectionViewLayout: UICollectionViewFlowLayout {
    
    var eDelegate : UICollectionViewDelegate?
    var eDataSource : UICollectionViewDataSource?
    
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = collectionView?.numberOfSections, let delegate = self.collectionView?.delegate as? EditCollectionViewLayoutDelegate else {
            
            
            return
        }
        
        decorationViewAttrs.removeAll()
        
        for section in 0 ..< numberOfSections {
            
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                  numberOfItems > 0,
                let firstCellAttr = self.layoutAttributesForItem(at: IndexPath.init(item: 0, section: section)),
                let lastItemAttr = self.layoutAttributesForItem(at: IndexPath.init(item: numberOfItems - 1, section: section)) else {
                
                continue
            }
            
            var eSectionInset = self.sectionInset
            
            if let inset = delegate.collectionView?(collectionView!, layout: self, insetForSectionAt: section) {
                
                eSectionInset = inset
            }
            
            var sectionFrame = CGRect.init(x: eSectionInset.left, y: firstCellAttr.frame.origin.y - eSectionInset.top, width: collectionViewContentSize.width - eSectionInset.left - eSectionInset.right, height: lastItemAttr.frame.origin.y + lastItemAttr.frame.height - firstCellAttr.frame.origin.y)
            
            sectionFrame.origin.x = eSectionInset.left
            sectionFrame.origin.y += eSectionInset.top
            
            if scrollDirection == .horizontal {
                
                sectionFrame.size.width += eSectionInset.left + eSectionInset.right
                sectionFrame.size.height = collectionView!.frame.size.height
            }else {
                
                sectionFrame.size.width = collectionView!.frame.size.width - eSectionInset.left - eSectionInset.right
                sectionFrame.size.height += eSectionInset.bottom
                
            }
            
            let attr = EditDecorationCollectionViewLayoutAttributes.init(forDecorationViewOfKind: DecorationViewElementKind, with: IndexPath.init(item: 0, section: section))
            
            attr.frame = sectionFrame
            attr.zIndex = -1
            
            attr.bgColor = delegate.backgroundDecorationViewColor(collectionView: collectionView!, layout: self, section: section)
            attr.cornerRedius = delegate.cornerRadiusForDecorationView(collectionView: collectionView!, layout: self, section: section)
            
            self.decorationViewAttrs.append(attr)
            
        }
        
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == DecorationViewElementKind {
            
            return self.decorationViewAttrs[indexPath.section]
            
        }
        
        return super.layoutAttributesForDecorationView(ofKind: DecorationViewElementKind, at: indexPath)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attrs = super.layoutAttributesForElements(in: rect)
        
        attrs?.append(contentsOf: self.decorationViewAttrs.filter {
            
            return rect.intersects($0.frame)
        })
        
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    override init() {
        super.init()
        
        register(EditDecorationView.self, forDecorationViewOfKind: DecorationViewElementKind)
        
        eDelegate = collectionView?.delegate
        eDataSource = collectionView?.dataSource

    }
    
    override func awakeFromNib() {
        
        register(EditDecorationView.self, forDecorationViewOfKind: DecorationViewElementKind)
        
        eDelegate = collectionView?.delegate
        eDataSource = collectionView?.dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return false
    }
}
