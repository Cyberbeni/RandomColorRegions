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
    var start: CGPoint
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
