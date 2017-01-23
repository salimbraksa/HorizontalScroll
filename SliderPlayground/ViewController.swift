//
//  ViewController.swift
//  SliderPlayground
//
//  Created by salim on 1/18/17.
//  Copyright © 2017 Angstrom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: Slider!

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.configuration.itemSize.width = 250
    }

}

