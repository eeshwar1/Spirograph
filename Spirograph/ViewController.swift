//
//  ViewController.swift
//  SpirographView
//
//  Created by Venky Venkatakrishnan on 2/2/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var spirographView: SpirographView!
    @IBOutlet weak var sliderSmallRadius: NSSlider!
    @IBOutlet weak var sliderDotRadius: NSSlider!
 
    @IBOutlet weak var lblSmallRadius: NSTextField!
    @IBOutlet weak var lblDotRadius: NSTextField!
    
    
    var bigRadius: Double = 100
    var smallRadius: Double = 10
    var smallRadiusRatio: Double = 0.4
    var dotRadius: Double = 40
    var dotRadiusRatio: Double = 0.4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderSmallRadius.doubleValue = smallRadiusRatio
        sliderDotRadius.doubleValue = dotRadiusRatio
        
        setRadiusLabels()
    }
    
    func setRadiusLabels()
    {

        lblSmallRadius.stringValue = smallRadiusRatio.description
        lblDotRadius.stringValue = dotRadiusRatio.description
    }
    
    @IBAction func sliderValueChanged(sender: NSSlider) {
        
        switch sender {
        case sliderSmallRadius:
            smallRadiusRatio = sender.doubleValue.round(toDecimal: 2)
            smallRadius = bigRadius * smallRadiusRatio
        case sliderDotRadius:
            dotRadiusRatio = sender.doubleValue.round(toDecimal: 2)
        default:
            break
        }
        
        setRadiusLabels()
        
        self.spirographView.setSpirographValues(smallRadiusRatio: smallRadiusRatio, dotRadiusRatio: dotRadiusRatio)
    }
    
    // TODO: Fix Export
    // This function is now broken (does not export the spirograph shape
    // after animation and CAShapeLayer were added to SpirographView.
    @IBAction func exportImage(_ sender: AnyObject) {
      if let tiffdata = spirographView.snapshot().tiffRepresentation,
        let bitmaprep = NSBitmapImageRep(data: tiffdata) {
        
        let props = [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]
        if let bitmapData = NSBitmapImageRep.representationOfImageReps(in: [bitmaprep], using: .png, properties: props) {
          
          let path: NSString = "~/Desktop/Spirograph.jpg"
          let resolvedPath = path.expandingTildeInPath
          
          try! bitmapData.write(to: URL(fileURLWithPath: resolvedPath), options: [])
          
          print("Your image has been saved to \(resolvedPath)")
          
        }
      }
    }
}
