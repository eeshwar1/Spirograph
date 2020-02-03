//
//  CirclesView.swift
//  Circles
//
//  Created by Venky Venkatakrishnan on 2/2/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Cocoa

class CirclesView: NSView {

    var bigRadius: Double = 50
    var smallRadius: Double = 10
    var dotRadius: Double = 40
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    override func draw(_ dirtyRect: NSRect) {
    
        super.draw(dirtyRect)
        
        NSColor.lightGray.set()
        dirtyRect.fill()
        
        // triangleAnimation()
    
        // arcAnimation()
        
        // circleAnimation()
        
        // let center = NSPoint(x: 200.0, y: 200.0)
        // let center1 = NSPoint(x: 400, y: 400)
        //  spirograph(center: center, bigR: 50, smallR: 5, dotR: 40)
        
        //  spirograph(center: center1, bigR: 50, smallR: 2, dotR: 30)
        
        let center = NSPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        
        spirograph(center: center, bigR: bigRadius, smallR: smallRadius, dotR: dotRadius)
        
        

        
    }
    
    func setSpirographValues(bigRadius: Double, smallRadius: Double, dotRadius: Double)
    {
        self.bigRadius = bigRadius
        self.smallRadius = smallRadius
        self.dotRadius = dotRadius
        
        self.setNeedsDisplay(bounds)
        
    }
    
    func spirograph(center: NSPoint, bigR: Double, smallR: Double, dotR: Double)
    {
       
        
        let k: Double = smallR/bigR
        
        let l: Double = dotR/smallR
        
        NSColor.red.set()
        
        print("dotR: \(dotR), l: \(l), k: \(k)")
        for angle in stride(from: 0, through: 360, by: 0.01)
        {
            let angleRadians = Double(angle).toRadians
            
            let pointX1 = bigR * ((1 - k) * cos(angleRadians) + l * k * cos ((1.0 - k)/k * angleRadians))
            
            let pointY1 = bigR * ((1 - k) * sin(angleRadians) - l * k * sin ((1.0 - k)/k * angleRadians))
            
            let pointX = center.x + CGFloat(pointX1)
            let pointY = center.y + CGFloat(pointY1)
            
            let pointRect = NSRect(x: pointX, y: pointY, width: 1, height: 1)
            pointRect.fill()
        }
        
        
        
        
    }
    func circleAnimation()
    {


        let center = NSPoint(x: 200.0, y: 200.0)
        
        let radius: CGFloat = 100.0
        
        NSColor.red.set()
        
        for angle in 0...360
        {
            let pointX = center.x + radius * CGFloat(cos(deg2rad(Double(angle))))
            let pointY = center.y + radius * CGFloat(sin(deg2rad(Double(angle))))
            let pointRect = NSRect(x: pointX, y: pointY, width: 3, height: 3)
            pointRect.fill()
        }
        
    }
    
    func arcAnimation()
    {
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.bounds =  CGRect(x: 0, y: 0, width: 50, height: 50)
            shapeLayer.position = self.bounds.origin

            NSColor.red.setStroke()
            
            let path1 = NSBezierPath()
            path1.move(to: NSPoint(x: 100, y: 100))
            path1.appendArc(withCenter: NSPoint(x: 100,y: 100), radius: 50, startAngle: 180, endAngle: 270, clockwise: true)
            path1.close()
        
            let path2 = NSBezierPath()
            path2.move(to: NSPoint(x: 100,y: 100))
            path2.appendArc(withCenter: NSPoint(x: 100, y: 100), radius: 50, startAngle: 0, endAngle: 90, clockwise: true)
            path2.close()
            
            shapeLayer.fillColor = NSColor.blue.cgColor
        shapeLayer.strokeColor = NSColor.green.cgColor
            
            self.wantsLayer = true
            self.layer!.addSublayer(shapeLayer)
        
            let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
            animation.duration = 1.0
            animation.values = [path1.cgPath, path2.cgPath]
            animation.autoreverses = false
            animation.repeatDuration = 10.0
            animation.calculationMode = .linear
            
            shapeLayer.add(animation, forKey: nil)
    }
    
    func triangleAnimation()
    {
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.bounds =  CGRect(x: 0, y: 0, width: 50, height: 50)
            shapeLayer.position = self.bounds.origin

            NSColor.red.setStroke()
            
            let path1 = NSBezierPath()
            path1.move(to: CGPoint(x: 100,y: 100))
            path1.line(to: CGPoint(x: 200,y: 100))
            path1.line(to: CGPoint(x: 150,y: 200))
            path1.close()
            
            let path2 = NSBezierPath()
            path2.move(to: CGPoint(x: 100,y: 100))
            path2.line(to: CGPoint(x: 300,y: 300))
            path2.line(to: CGPoint(x: 350,y: 200))
            path2.close()
            
            shapeLayer.fillColor = NSColor.red.cgColor
            
            self.wantsLayer = true
            self.layer!.addSublayer(shapeLayer)
        
            let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
            animation.duration = 1.0
            animation.values = [path1.cgPath, path2.cgPath]
            animation.autoreverses = true
            animation.repeatDuration = 10.0
            animation.calculationMode = .linear
            
            shapeLayer.add(animation, forKey: nil)

    }
}

extension Double
{
    public var toRadians: Double {
        return self.magnitude * .pi / 180
    }
  
}


func deg2rad(_ number: Double) -> Double
{
    return number * .pi / 180
}

extension NSBezierPath {

    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                fatalError()
            }
        }

        return path
    }
}
