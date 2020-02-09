//
//  SpirographView.swift
//  SpirographView
//
//  Created by Venky Venkatakrishnan on 2/2/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Cocoa

enum Appearance {
    
    static let textFont: String = "HelveticaNeue-Bold"
    static let fontSize: CGFloat = 14
  
}
class SpirographView: NSView {

    var bigRadius: Double = 100
    var smallRadius: Double = 40
    var dotRadius: Double = 25
    
    var spiroPath = NSBezierPath()
    
    var backgroundColor: NSColor = .black
    var foregroundColor: NSColor = .white
    var textColor: NSColor = .yellow
    
    var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
        setupShapeLayer()
        self.wantsLayer = true
        self.layer!.addSublayer(shapeLayer)

    }

    func setupShapeLayer()
    {
        self.shapeLayer = CAShapeLayer()
                          
        self.shapeLayer.bounds =  CGRect(x: 0, y: 0, width: 500, height: 500)
        self.shapeLayer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
       
        self.shapeLayer.fillColor = NSColor.blue.cgColor
        shapeLayer.strokeColor = NSColor.green.cgColor
        
       
       
       
    }
    
    override func draw(_ dirtyRect: NSRect) {
    
        super.draw(dirtyRect)
        
        self.backgroundColor.set()
        
        self.bounds.fill()
            
        let center = NSPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        
        // bigRadius = Double((self.bounds.width < self.bounds.height ? self.bounds.width : self.bounds.height) * 0.4)
        
        spirographEx(center: center, bigR: bigRadius, smallR: smallRadius, dotR: dotRadius)
       
        displayAttributeData()
        
    }
    
    func renderImage() -> NSImage {
        
        let image: NSImage = NSImage(size: NSSize(width: 500,height: 500))
        
        image.lockFocus()

        let context = NSGraphicsContext.current!.cgContext
        
        self.shapeLayer.path = spiroPath.cgPath
       
        NSColor.black.set()
        self.shapeLayer.bounds.fill()
        
        displayAttributeData()
        
        self.shapeLayer.render(in: context)
        
        image.unlockFocus()
        
        return image
        
    }
    
    func displayAttributeData() {
        
        let string: NSString = "Big Radius: \(bigRadius)\nSmall Radius: \(smallRadius) \nDot Radius: \(dotRadius)" as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
                        
        let attrs = [NSAttributedString.Key.font: NSFont(name: Appearance.textFont , size: Appearance.fontSize)!, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: self.textColor]
       
               
        string.draw(in: CGRect(x: 10, y: 390, width: 200, height: 100), withAttributes: attrs)
    }
    
    func setSpirographValues(sizeRatio: Double, smallRadiusRatio: Double, dotRadiusRatio: Double)
    {
    
        self.bigRadius = (Double((self.bounds.width < self.bounds.height ? self.bounds.width : self.bounds.height)) * 0.8 * sizeRatio/2).round(toDecimal: 2)
        self.smallRadius = (bigRadius * smallRadiusRatio).round(toDecimal: 2)
        self.dotRadius = (smallRadius * dotRadiusRatio).round(toDecimal: 2)
        
        self.setNeedsDisplay(bounds)
        
    }
    
    func spirograph(center: NSPoint, bigR: Double, smallR: Double, dotR: Double)
    {
    
        let k: Double = smallR/bigR
        
        let l: Double = dotR/smallR
        
        self.foregroundColor.set()
        
        let OneMinusK: Double = 1.0 - k
        let OneMinusKByK: Double = (1.0 - k)/k

        for angle in stride(from: 0, through: 1080, by: 0.1)
        {
            let angleRadians = Double(angle).toRadians
            
            let pointX1 = bigR * (OneMinusK * cos(angleRadians) + l * k * cos(OneMinusKByK * angleRadians))
            
            let pointY1 = bigR * ((1 - k) * sin(angleRadians) - l * k * sin (OneMinusKByK * angleRadians))
            
            let pointX = center.x + CGFloat(pointX1)
            let pointY = center.y + CGFloat(pointY1)
            
            let pointRect = NSRect(x: pointX, y: pointY, width: 2, height: 2)
            pointRect.fill()
            
            self.setNeedsDisplay(pointRect)
        }
    
    }
    
    
    func spirographEx(center: NSPoint, bigR: Double, smallR: Double, dotR: Double)
     {
        
        let prevSpiroPath = spiroPath
                    
        spiroPath = NSBezierPath()
    
        let k: Double = smallR/bigR
        
        let l: Double = dotR/smallR
        
        self.foregroundColor.set()

        let currentPoint = spiroPointAtAngle(angle: 0, center: center, k: k, l: l)
        
        spiroPath.move(to: currentPoint)
    
        for angle in stride(from: 0.0, through: 1080, by: 1)
         {
             
            let newPoint = spiroPointAtAngle(angle: angle, center: center, k: k, l: l)
            spiroPath.line(to: newPoint)

         }
        
        animatePath(oldPath: prevSpiroPath, newPath: spiroPath)
    
     
     }
    
    func animatePath(oldPath: NSBezierPath, newPath: NSBezierPath)
    {
        
       let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        animation.duration = 1.0
        animation.values = [oldPath.cgPath, newPath.cgPath]
        animation.calculationMode = .linear
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both
         
        shapeLayer.add(animation, forKey: nil)

    }

    func spiroPointAtAngle(angle: Double, center: NSPoint, k: Double, l: Double) -> NSPoint {
        
        
        let OneMinusK: Double = 1.0 - k
        let OneMinusKByK: Double = (1.0 - k)/k
        
        let angleRadians = Double(angle).toRadians
        
        let pointX1 = bigRadius * (OneMinusK * cos(angleRadians) + l * k * cos(OneMinusKByK * angleRadians))
        
        let pointY1 = bigRadius * ((1 - k) * sin(angleRadians) - l * k * sin (OneMinusKByK * angleRadians))
        
        let pointX = center.x + CGFloat(pointX1)
        let pointY = center.y + CGFloat(pointY1)
        
        return NSPoint(x: pointX, y: pointY)
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

            self.foregroundColor.setStroke()
            
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

            self.foregroundColor.setStroke()
            
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
