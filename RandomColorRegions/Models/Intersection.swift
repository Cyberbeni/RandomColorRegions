//
//  Intersection.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 09..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import CoreGraphics

class Intersection: Comparable {
    var line: Line
    var point: CGFloat
    
    init(line: Line, point: CGFloat) {
        self.line = line
        self.point = point
    }
    
    static func < (lhs: Intersection, rhs: Intersection) -> Bool {
        return lhs.point < rhs.point
    }
    
    static func == (lhs: Intersection, rhs: Intersection) -> Bool {
        return lhs.point == rhs.point
    }
}
