//
//  CreditCardCell.swift
//  SliderPlayground
//
//  Created by salim on 1/24/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

enum CreditCardType: Int {
    
    case mastercard = 0
    case visa = 1
 
    var backgroundColor: UIColor {
        switch self {
        case .mastercard: return UIColor(red:0.07, green:0.20, blue:0.43, alpha:1.00)
        case .visa: return UIColor(red:0.23, green:0.66, blue:0.72, alpha:1.00)
        }
    }
    
    var logo: UIImage {
        switch self {
        case .mastercard: return #imageLiteral(resourceName: "mastercard")
        case .visa: return #imageLiteral(resourceName: "visa")
        }
    }
    
}

class CreditCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "credit-card-cell"
    static let nib = "CreditCardCell"
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var creditCardImageView: UIImageView!
    
    func configure(with type: CreditCardType) {
        
        backgroundColor = type.backgroundColor
        creditCardImageView.image = type.logo
        
        // Shadow cell
        let shadowColor = type.backgroundColor.withAlphaComponent(0.81)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 12)
        layer.shadowRadius = 40
        layer.shadowOpacity = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        
        // Shadow all labels
        for label in labels {
            
            label.layer.shadowColor = UIColor(red:0.20, green:0.25, blue:0.29, alpha:1.00).cgColor
            label.layer.shadowOffset = CGSize(width: 0, height: 1)
            label.layer.shadowRadius = 1
            label.layer.shadowOpacity = 0.7
            label.layer.rasterizationScale = UIScreen.main.scale
            label.layer.shouldRasterize = true
            
        }
        
    }
    
}
