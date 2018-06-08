//
//  DrawableCollectionLayer.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 09..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import UIKit

class DrawableCollectionLayer: CALayer {
    private var elementsToAdd = [Drawable]()
    private var needsToClear = false
    private var savedImage: CGImage?
    private var color: CGColor?
    
    init(color: CGColor? = nil) {
        super.init()
        
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        if let color = self.color {
            context.setStrokeColor(color)
            context.setFillColor(color)
        }
        context.setLineWidth(2)
        
        elementsToAdd.forEach { (element) in
            if self.color == nil {
                let randomColor = UIColor.random.cgColor
                context.setStrokeColor(randomColor)
                context.setFillColor(randomColor)
            }
            element.draw(in: context)
        }
        elementsToAdd.removeAll()
        
        self.savedImage = context.makeImage()
    }
    
    func add(elementToDraw: Drawable) {
        self.elementsToAdd.append(elementToDraw)
        self.setNeedsDisplay()
    }
}
