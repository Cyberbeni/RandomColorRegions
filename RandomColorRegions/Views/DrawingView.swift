//
//  DrawingView.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 08..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    // MARK: static parameters
    private let minimumLineLength: CGFloat = 20.0
    
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: - public functions
    
    @objc func reset() {
        self.regionsLayer.reset()
        self.linesLayer.reset()
        self.regionGenerator.reset()
    }
    
    // MARK: - overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // add new current line layer
        touches.forEach { (touch) in
            let newLayer = CurrentLineLayer(frame: self.layer.bounds, point: touch.location(in: self))
            self.currentLineLayers[touch] = newLayer
            self.layer.addSublayer(newLayer)
            newLayer.setNeedsDisplay()
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // modify the corresponding current line layers
        touches.forEach { (touch) in
            if let layer = self.currentLineLayers[touch] {
                layer.update(endPoint: touch.location(in: self))
            }
        }
        
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouchesEnded(touches)
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // consider canceling the drawing instead of finishing it
        self.handleTouchesEnded(touches)
        
        super.touchesCancelled(touches, with: event)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        if layer == self.layer {
            layer.sublayers?.forEach({ (sublayer) in
                sublayer.frame = layer.bounds
            })
        }
        
        super.layoutSublayers(of: layer)
    }
    
    // MARK: - private variables
    
    private let regionsLayer = DrawableCollectionLayer<Region>()
    private let linesLayer = DrawableCollectionLayer<Line>(color: UIColor.blue.cgColor)
    private var currentLineLayers = Dictionary<UITouch, CurrentLineLayer>()
    
    private let regionGenerator = RegionGenerator()
    
    // MARK: - private functions
    
    private func setup() {
        self.backgroundColor = .white
        
        self.layer.addSublayer(self.regionsLayer)
        self.layer.addSublayer(self.linesLayer)
        self.currentLineLayers.reserveCapacity(8)
    }
    
    private func handleTouchesEnded(_ touches: Set<UITouch>) {
        // move lines to lines layer and calculate new regions
        touches.forEach { (touch) in
            if let layer = self.currentLineLayers[touch] {
                layer.removeFromSuperlayer()
                self.currentLineLayers.removeValue(forKey: touch)
                
                let line = layer.line
                line.end = touch.location(in: self)
                if line.lengthSquared > self.minimumLineLength * self.minimumLineLength {
                    self.linesLayer.add(elementsToDraw: line)
                    self.regionsLayer.add(elementsToDraw: self.regionGenerator.add(line: line))
                }
            }
        }
    }
}
