//
//  ViewController.swift
//  Circles
//
//  Created by Venky Venkatakrishnan on 2/2/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var CirclesView: CirclesView!
    @IBOutlet weak var sliderBigRadius: NSSlider!
    @IBOutlet weak var sliderSmallRadius: NSSlider!
    @IBOutlet weak var sliderDotRadius: NSSlider!
    
    var bigRadius: Double = 100
    var smallRadius: Double = 10
    var dotRadius: Double = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderBigRadius.doubleValue = bigRadius
        sliderSmallRadius.doubleValue = smallRadius
        sliderDotRadius.doubleValue = dotRadius
        
    }
    
    @IBAction func sliderValueChanged(sender: NSSlider) {
        
        switch sender {
        case sliderBigRadius:
            bigRadius = sender.doubleValue
        case sliderSmallRadius:
            smallRadius = sender.doubleValue
        case sliderDotRadius:
            dotRadius = sender.doubleValue
        default:
            break
        }
        
        self.CirclesView.setSpirographValues(bigRadius: bigRadius, smallRadius: smallRadius, dotRadius: dotRadius)
    }
    
}
