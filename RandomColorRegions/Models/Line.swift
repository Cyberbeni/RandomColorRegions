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
    
    init(point: CGPoint) {
        self.start = point
        self.end = point
    }
    
    var lengthSquared: CGFloat {
        let deltaX = start.x - end.x
        let deltaY = start.y - end.y
        return deltaX * deltaX + deltaY * deltaY
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
