//
//  Pagination.swift
//  SliderPlayground
//
//  Created by salim on 1/23/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

protocol PaginationDataSource: class {
    
    func pageWidth(forPagination pagination: Pagination) -> CGFloat
    
}

class Pagination: NSObject, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var dataSource: PaginationDataSource!
    
    // MARK: - Initializer
    
    convenience init(scrollView: UIScrollView) {
        self.init()
//        scrollView.delegate = self
    }
    
    // MARK: - UIScrollViewDelegate Protocol Methods
    
    var currentPage: Int = 0
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        let pageWidth = dataSource.pageWidth(forPagination: self)
        let xCurrentOffset = scrollView.contentOffset.x
        currentPage = Int(floor((xCurrentOffset - pageWidth / 2) / pageWidth)) + 1
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = dataSource.pageWidth(forPagination: self)
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
