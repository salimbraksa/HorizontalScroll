//
//  ViewController.swift
//  SliderPlayground
//
//  Created by salim on 1/18/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = Bundle.main.loadNibNamed("Slider", owner: self, options: nil)?.first as! Slider
        self.view.addSubview(view)
        view.frame = CGRect(origin: CGPoint(x: 0, y: 150), size: CGSize(width: 375, height: 200))
        
    }

}

