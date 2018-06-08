//
//  Drawable.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 09..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import CoreGraphics

protocol Drawable {
    func draw(in context: CGContext)
}
