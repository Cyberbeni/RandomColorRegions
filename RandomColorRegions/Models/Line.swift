//
//  Line.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 08..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import Foundation
import CoreGraphics

class Line {
    private(set) var start: CGPoint
    var end: CGPoint
    
    // between 0 and 2 PI
    private(set) var lhsForwardAngle: CGFloat = 0
    private(set) var lhsBackwardAngle: CGFloat = 0
    // between -PI and PI
    private(set) var rhsForwardAngle: CGFloat = 0
    private(set) var rhsBackwardAngle: CGFloat = 0
    
    var intersections = SortedArray<Intersection>()
    
    init(point: CGPoint) {
        self.start = point
        self.end = point
    }
    
    var lengthSquared: CGFloat {
        let deltaX = start.x - end.x
        let deltaY = start.y - end.y
        return deltaX * deltaX + deltaY * deltaY
    }
    
    func calculateAngles() {
        if start.x == end.x {
            if end.y > start.y {
                self.lhsForwardAngle = .pi / 2
                self.lhsBackwardAngle = 3 * .pi / 2
                self.rhsForwardAngle = .pi / 2
                self.rhsBackwardAngle = -(.pi / 2)
            } else {
                self.lhsForwardAngle = 3 * .pi / 2
                self.lhsBackwardAngle = .pi / 2
                self.rhsForwardAngle = -(.pi / 2)
                self.rhsBackwardAngle = .pi / 2
            }
            return
        }
        
        let m = (end.y - start.y) / (end.x - start.x)
        let angle = atan(m)
        
        switch (end.y > start.y, end.x > start.x) {
        // angle: 0 - 90
        case (true, true):
            self.lhsForwardAngle = angle
            self.lhsBackwardAngle = angle + .pi
            self.rhsForwardAngle = angle
            self.rhsBackwardAngle = angle - .pi
        // angle: 90 - 180
        case (true, false):
            self.lhsForwardAngle = angle + .pi
            self.lhsBackwardAngle = angle + 2 * .pi
            self.rhsForwardAngle = angle + .pi
            self.rhsBackwardAngle = angle
        // angle: 180-270
        case (false, false):
            self.lhsForwardAngle = angle + .pi
            self.lhsBackwardAngle = angle
            self.rhsForwardAngle = angle - .pi
            self.rhsBackwardAngle = angle
        // angle: 270 - 360
        case (false, true):
            self.lhsForwardAngle = angle + 2 * .pi
            self.lhsBackwardAngle = angle + .pi
            self.rhsForwardAngle = angle
            self.rhsBackwardAngle = angle + .pi
        }
    }
    
    // http://www.ambrsoft.com/MathCalc/Line/TwoLinesIntersection/TwoLinesIntersection.htm
    func intersectionPoint(with line: Line) -> (own: CGFloat, others: CGFloat)? {
        guard self.lengthSquared > 0, line.lengthSquared > 0 else { return nil }
        
        let (x1, y1) = (self.start.x, self.start.y)
        let (x2, y2) = (self.end.x, self.end.y)
        let (x3, y3) = (line.start.x, line.start.y)
        let (x4, y4) = (line.end.x, line.end.y)
        
        let denominator = (x2 - x1) * (y4 - y3) - (x4 - x3) * (y2 - y1)
        guard denominator != 0 else { return nil }
        
        let numeratorX = (x2 * y1 - x1 * y2) * (x4 - x3) - (x4 * y3 - x3 * y4) * (x2 - x1)
        let numeratorY = (x2 * y1 - x1 * y2) * (y4 - y3) - (x4 * y3 - x3 * y4) * (y2 - y1)
        
        let (x, y) = (numeratorX / denominator, numeratorY / denominator)
        
        var own: CGFloat = 0
        if x1 != x2 {
            own = (x - x1) / (x2 - x1)
        } else {
            own = (y - y1) / (y2 - y1)
        }
        guard own > 0, own < 1 else { return nil }
        
        var others: CGFloat = 0
        if x3 != x4 {
            others = (x - x3) / (x4 - x3)
        } else {
            others = (y - y3) / (y4 - y3)
        }
        guard others > 0, others < 1 else { return nil }
        
        return (own,others)
    }
}

extension Line: Drawable {
    func draw(in context: CGContext) {
        context.beginPath()
        context.move(to: self.start)
        context.addLine(to: self.end)
        context.strokePath()
    }
}

extension Line: CustomStringConvertible {
    var description: String {
        return "Line:\n\(self.lhsForwardAngle);\(self.lhsBackwardAngle)\n\(self.rhsForwardAngle);\(self.rhsBackwardAngle)\n"
    }
}
