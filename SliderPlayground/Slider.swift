//
//  Slider.swift
//  SliderPlayground
//
//  Created by salim on 1/18/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

protocol SliderDataSource: class {
    
    func slider(_ slider: Slider, cellForItemAt index: Int) -> UICollectionViewCell
    
    func numberOfItems(inSlider slider: Slider) -> Int
    
    func sizeForItems(with slider: Slider) -> CGSize
    
}

class Slider: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
        
    // MARK: - Views
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var dataSource: SliderDataSource!
    
    fileprivate(set) var currentPage: Int = 0
    fileprivate var pageWidth: CGFloat {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        return dataSource.sizeForItems(with: self).width + layout.minimumInteritemSpacing
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        // Instantiate collection view
        guard let collectionView = Bundle.main.loadNibNamed("Slider", owner: self, options: nil)?.first as? UICollectionView else { return }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = bounds
        addSubview(collectionView)
        self.collectionView = collectionView
        
        // Configure collection view
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell-id")
        
        // Set up collection view layout
        let layout = SliderLayout()
        collectionView.collectionViewLayout = layout
        
    }
    
    // MARK: - UICollectionViewDataSource Protocl Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems(inSlider: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.slider(self, cellForItemAt: indexPath.row)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = dataSource.sizeForItems(with: self)
        if size.height < 0 {
            size.height = bounds.height
        }
        return size
    }
    
    // MARK: - Dequeue
    
    func dequeueReusableCell(withReuseIdentifier reuseIdentifier: String, forIndex index: Int) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: IndexPath(item: index, section: 0))
    }
    
    // MARK: - Register Cells
    
    func register(nib: UINib?, forCellWithReusueIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
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

