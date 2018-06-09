//
//  Intersection.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 09..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import CoreGraphics

class Intersection: Comparable {
    weak var selfLine: Line!
    weak var line: Line!
    var point: CGFloat
    var isRightHanded = true
    var isForward = true
    
    init(selfLine: Line, line: Line, point: CGFloat) {
        self.selfLine = selfLine
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
