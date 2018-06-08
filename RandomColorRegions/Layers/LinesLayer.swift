//
//  LinesLayer.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 08..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import UIKit

class LinesLayer: CALayer {
    var linesToAdd = [Line]()
    var needsToClear = false
    var savedImage: CGImage?
    
    func reset() {
        self.needsToClear = true
        self.setNeedsDisplay()
    }
    
    override func draw(in context: CGContext) {
        if self.needsToClear {
            context.clear(self.bounds)
            self.needsToClear = false
        } else if let savedImage = self.savedImage {
            context.translateBy(x: 0, y: self.bounds.height)
            context.scaleBy(x: 1, y: -1)
            context.draw(savedImage, in: self.bounds)
            context.translateBy(x: 0, y: self.bounds.height)
            context.scaleBy(x: 1, y: -1)
        }
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(2)
        
        linesToAdd.forEach { (line) in
            context.beginPath()
            context.move(to: line.start)
            context.addLine(to: line.end)
            context.strokePath()
        }
        linesToAdd.removeAll()
        
        self.savedImage = context.makeImage()
    }
}
