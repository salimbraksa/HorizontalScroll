//
//  ViewController.swift
//  SliderPlayground
//
//  Created by salim on 1/18/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SliderDataSource {
    
    @IBOutlet weak var slider: Slider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.dataSource = self
        let nib = UINib(nibName: "CreditCardCell", bundle: nil)
        slider.register(nib: nib, forCellWithReusueIdentifier: CreditCardCell.reuseIdentifier)
        
    }
    
    func slider(_ slider: Slider, cellForItemAt index: Int) -> UICollectionViewCell {
        
        let cell = slider.dequeueReusableCell(withReuseIdentifier: "credit-card-cell", forIndex: index) as! CreditCardCell
        cell.configure(with: CreditCardType(rawValue: index)!)
        return cell
        
    }
    
    func numberOfItems(inSlider slider: Slider) -> Int {
        return 2
    }
    
    func sizeForItems(with slider: Slider) -> CGSize {
        return CGSize(width: 320, height: -1)
    }

}

