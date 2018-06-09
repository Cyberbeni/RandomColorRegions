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
    private var start: CGPoint
    var end: CGPoint
    
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
