//
//  CurrentLineLayer.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 08..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import UIKit

class CurrentLineLayer: CALayer {
    var line: Line
    
    // MARK: initialization
    
    init(frame: CGRect, point: CGPoint) {
        self.line = Line(point: point)
        super.init()
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in context: CGContext) {
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(2)
        
        context.beginPath()
        context.move(to: line.start)
        context.addLine(to: line.end)
        context.strokePath()
    }
}
