//
//  Extensions.swift
//  SpirographView
//
//  Created by Venky Venkatakrishnan on 2/5/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Foundation
import Cocoa

extension Double
{
    public var toRadians: Double {
        return self.magnitude * .pi / 180
    }
  
}

extension Double {
    func round(toDecimal fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
      
    }
}

extension NSView {
  /**
   Take a snapshot of a current state NSView and return an NSImage
   
   - returns: NSImage representation
   */
  func snapshot() -> NSImage {
    let pdfData = dataWithPDF(inside: bounds)
    let image = NSImage(data: pdfData)
    return image ?? NSImage()
  }
}


func deg2rad(_ number: Double) -> Double
{
    return number * .pi / 180
}
