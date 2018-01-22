//
//  UIBezierPath+Extensions.swift
//  Vindur
//
//  Created by Mateusz on 28.11.2017.
//  Copyright © 2017 Vindur. All rights reserved.
//

import UIKit
import Arithmos

extension UIBezierPath {
    convenience public init(circleSliceFrom startPoint:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat) {
        self.init()
        self.move(to: startPoint)
        self.addLine(to: CGPoint(x: startPoint.x+radius, y: startPoint.y))
        self.addArc(withCenter: startPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.addLine(to: startPoint)
    }
    
    convenience public init(donutIn bounds: CGRect, andThickness thickness:CGFloat) {
        self.init(ovalIn: bounds)
        self.addArc(withCenter: bounds.center, radius: bounds.incircleRadius, startAngle: 0, endAngle: CGFloat.pi * 2.0, clockwise: true)
    }
    
    public var center: CGPoint {
        get {
            let boundingBox  = self.cgPath.boundingBox
            return CGPoint(x: boundingBox.midX, y: boundingBox.midY)
        }
        set(newCenter) {
            moveCenter(to:newCenter)
        }
    }
    
    @discardableResult public func rotate(with angle:CGFloat) -> Self {
        return applyCentered(CGAffineTransform(rotationAngle: angle))
    }
    
    @discardableResult public func moveCenter(to point:CGPoint) -> Self {
        let center = bounds.center
        let vector = center.vector(to: point)
        return moveCenter(by: vector)
    }
    
    @discardableResult public func moveCenter(by vector:CGVector) -> Self {
        return applyCentered(CGAffineTransform(translationX: vector.dx, y: vector.dy))
    }
    
    @discardableResult public func fit(into:CGRect) -> Self {
        return fit(into: into.size).moveCenter(to: into.center)
    }
    
    @discardableResult public func fit(into:CGSize) -> Self {
        let boundingBox = self.cgPath.boundingBox
        let widthScale = into.width/boundingBox.width
        let heightScale = into.height/boundingBox.height
        let factor = min(widthScale, heightScale)
        
        return scale(x: factor, y: factor)
    }
    
    @discardableResult public func scale(x:CGFloat, y:CGFloat) -> Self {
        return applyCentered(CGAffineTransform(scaleX: x, y: y))
    }
    
    @discardableResult public func applyCentered(_ transform: CGAffineTransform ) -> Self {
        let boundingBox  = self.cgPath.boundingBox
        let center = boundingBox.center
        let offsetCenter = CGAffineTransform(translationX: -center.x, y: -center.y)
        let revertCenter =  CGAffineTransform(translationX: center.x, y: center.y)
        
        let centeredTransform  = CGAffineTransform.identity.concatenating(offsetCenter).concatenating(transform).concatenating(revertCenter)
        
        apply(centeredTransform)
        
        return self
    }
}

