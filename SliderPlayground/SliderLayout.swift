//
//  SliderLayout.swift
//  SliderPlayground
//
//  Created by salim on 1/23/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

class SliderLayout: UICollectionViewFlowLayout {
    
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            guard let attributes = layoutAttributesForItem(at: indexPath)?.copy(with: nil) as? UICollectionViewLayoutAttributes else { continue }
            cachedAttributes.append(attributes)
            attributes.frame.origin.x = self.xOrigin(atIndex: item)
        }
        
        if let attributes = cachedAttributes.first {
            minimumInteritemSpacing = spacing(with: attributes)
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        var contentSize = super.collectionViewContentSize
        contentSize.width = cachedAttributes.last!.frame.origin.x + cachedAttributes.last!.frame.size.width + cachedAttributes.first!.frame.origin.x
        return contentSize
    }
    
    // MARK: - Calculting X origin
    
    private func xOrigin(atIndex index: Int) -> CGFloat {
        
        let previousAttributes = self.cachedAttributes[index == 0 ? 0 : index - 1]
        let currentAttributes = self.cachedAttributes[index]
        
        if index == 0 {
            return (collectionView!.bounds.width - currentAttributes.size.width) / 2
        } else {
            return previousAttributes.frame.origin.x + previousAttributes.size.width + spacing(with: cachedAttributes[0])
        }
        
    }
    
    func spacing(with attributes: UICollectionViewLayoutAttributes) -> CGFloat {
        return collectionView!.bounds.width - attributes.size.width * 0.05 - attributes.size.width - attributes.frame.origin.x
    }
    
}
