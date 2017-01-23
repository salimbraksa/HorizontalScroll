//
//  Slider.swift
//  SliderPlayground
//
//  Created by salim on 1/18/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

class Slider: UIView, UIScrollViewDelegate {
    
    // MARK: - Views
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var testView: UIView!
    
    // MARK: - Constraints
    
    @IBOutlet weak var itemWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftPaddingConstraint: NSLayoutConstraint!
    
    // MARK: - Initializer
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update left padding
        leftPaddingConstraint.constant = (bounds.width - itemWidthConstraint.constant) / 2
        
    }
    
    // MARK: - DEL
    
    var initialContentOffset: CGPoint = .zero
    var draggedDistance: CGFloat = 0
    var currentPage: Int = 0
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        let pageWidth = Float(itemWidthConstraint.constant + stackView.spacing)
        let xCurrentOffset = Float(scrollView.contentOffset.x)
        currentPage = Int(floor((xCurrentOffset - pageWidth / 2) / pageWidth)) + 1
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        draggedDistance = scrollView.contentOffset.x - initialContentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(itemWidthConstraint.constant + stackView.spacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(scrollView.contentSize.width)
        
        var newPage = currentPage
        if velocity.x == 0 {
            newPage = Int(floor((targetXContentOffset - pageWidth / 2) / pageWidth)) + 1
        } else {
            newPage = velocity.x > 0 ? currentPage + 1 : currentPage - 1
            if newPage < 0 {
                newPage = 0
            }
            if Float(newPage) > contentWidth / pageWidth {
                newPage = Int(ceil(contentWidth / pageWidth)) - 1
            }
        }
        targetContentOffset.pointee.x = CGFloat(Float(newPage) * pageWidth)
        
    }

}
