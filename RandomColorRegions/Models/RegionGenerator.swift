//
//  RegionGenerator.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 09..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import CoreGraphics

class RegionGenerator {
    private var lines = [Line]()
    
    func add(line: Line) -> [Region] {
        let newRegions = [Region(points: [CGPoint(x: 10, y: 10),CGPoint(x: 10, y: 100),CGPoint(x: 100, y: 100),CGPoint(x: 100, y: 10)])]
        
        self.lines.append(line)
        
        return newRegions
    }
}
