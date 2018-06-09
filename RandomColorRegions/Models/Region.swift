//
//  Region.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 09..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import CoreGraphics

class Region {
    // MARK: initialization
    init(points: [CGPoint]) {
        self.points = points
    }
    
    // MARK: - private variables
    
    private let points: [CGPoint]
}

// MARK: - protocol extension

extension Region: Drawable {
    func draw(in context: CGContext) {
        guard self.points.count > 2, let firstPoint = self.points.first else { return }
        
        context.beginPath()
        context.move(to: firstPoint)
        self.points.dropFirst().forEach { (point) in
            context.addLine(to: point)
        }
        context.addLine(to: firstPoint)
        context.fillPath()
    }
}
