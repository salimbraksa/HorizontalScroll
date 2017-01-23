//
//  Slider.swift
//  SliderPlayground
//
//  Created by salim on 1/18/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

class Slider: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: - Views
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    fileprivate var configuration = Configuration()
    fileprivate(set) var currentPage: Int = 0
    fileprivate var pageWidth: CGFloat {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        return configuration.itemSize.width + layout.minimumInteritemSpacing
    }
    
    // MARK: - Initializer
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        configure(with: configuration)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        
        // Configure collection view
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell-id")
        
        // Set up collection view layout
        let layout = SliderLayout()
        collectionView.collectionViewLayout = layout
        
    }
    
    // MARK: - Configuration
    
    func configure(with configuration: Configuration) {
        self.configuration = configuration
        collectionView.reloadData()
    }
    
    struct Configuration {
        var itemSize: CGSize = CGSize(width: 300, height: -1)
        var visibleItemPortion = 0.05
    }
    
    
    // MARK: - UICollectionViewDataSource Protocl Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-id", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = configuration.itemSize.height == -1 ? bounds.height : configuration.itemSize.height
        return CGSize(width: configuration.itemSize.width, height: height)
    }
    
}

// MARK: - Pagination Behavior

extension Slider {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        let xCurrentOffset = scrollView.contentOffset.x
        currentPage = Int(floor((xCurrentOffset - pageWidth / 2) / pageWidth)) + 1
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetXContentOffset = targetContentOffset.pointee.x
        let contentWidth = scrollView.contentSize.width
        
        var newPage = currentPage
        if velocity.x == 0 {
            newPage = Int(floor((targetXContentOffset - pageWidth / 2) / pageWidth)) + 1
        } else {
            newPage = velocity.x > 0 ? currentPage + 1 : currentPage - 1
            if newPage < 0 {
                newPage = 0
            }
            if CGFloat(newPage) > contentWidth / pageWidth {
                newPage = Int(ceil(contentWidth / pageWidth)) - 1
            }
        }
        targetContentOffset.pointee.x = CGFloat(CGFloat(newPage) * pageWidth)
        
    }
    
}

