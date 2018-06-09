//
//  RegionGenerator.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 09..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import Foundation
import CoreGraphics

class RegionGenerator {
    // MARK: public functions
    func reset() {
        lines.removeAll()
    }
    
    func add(line: Line) -> [Region] {
        line.calculateAngles()
        lines.forEach { (storedLine) in
            if let intersectionPoint = line.intersectionPoint(with: storedLine) {
                line.intersections.insert(Intersection(selfLine: line, line: storedLine, point: intersectionPoint.own))
                storedLine.intersections.insert(Intersection(selfLine: storedLine, line: line, point: intersectionPoint.others))
            }
        }
        
        var newRegionIntersectionArrays = [[Intersection]]()
        line.intersections.dropLast().indices.forEach { (index) in
            for isRightHanded in [true, false] {
                print("--- \(isRightHanded ? "right" : "left")")
                var pointArray = [Intersection]()
                let firstIntersection = line.intersections[index]
                pointArray.append(firstIntersection)
                pointArray.append(line.intersections[index + 1])
                pointArray.last?.isRightHanded = isRightHanded
                pointArray.last?.isForward = true
                while true {
                    var nextIntersection: Intersection?
                    var isForward = true
                    guard let currentIntersection = pointArray.last,
                        var nextIndex = self.getIndex(for: currentIntersection.selfLine, in: currentIntersection.line?.intersections),
                        let currentLine = currentIntersection.selfLine,
                        let nextLine = currentIntersection.line
                        else {
                            break
                    }
                    print(currentLine.description)
                    var minAngle = CGFloat()
                    var maxAngle = CGFloat()
                    switch (currentIntersection.isRightHanded, currentIntersection.isForward) {
                    case (true, true):
                        minAngle = currentLine.lhsForwardAngle - .pi
                        maxAngle = currentLine.lhsForwardAngle
                    case (true, false):
                        minAngle = currentLine.lhsBackwardAngle - .pi
                        maxAngle = currentLine.lhsBackwardAngle
                    case (false, true):
                        minAngle = currentLine.rhsForwardAngle
                        maxAngle = currentLine.rhsForwardAngle + .pi
                    case (false, false):
                        minAngle = currentLine.rhsBackwardAngle
                        maxAngle = currentLine.rhsBackwardAngle + .pi
                    }
                    
                    if minAngle < 0 {
                        minAngle += 2 * .pi
                        maxAngle += 2 * .pi
                    }
                    var forwardAngle = nextLine.lhsForwardAngle
                    if forwardAngle < minAngle {
                        forwardAngle += 2 * .pi
                    }
                    if forwardAngle < maxAngle {
                        nextIndex += 1
                    } else {
                        nextIndex -= 1
                        isForward = false
                    }
                    
                    if nextLine.intersections.indices.contains(nextIndex) {
                        nextIntersection = nextLine.intersections[nextIndex]
                        nextIntersection?.isRightHanded = isRightHanded
                        nextIntersection?.isForward = isForward
                    } else {
                        break
                    }
                    
                    if let nextIntersection = nextIntersection {
                        if firstIntersection.line === nextIntersection.selfLine && firstIntersection.selfLine === nextIntersection.line {
                            newRegionIntersectionArrays.append(pointArray)
                            break
                        } else {
                            if pointArray.contains(nextIntersection) {
                                //
                                break
                            }
                            print(nextIntersection.isForward ? "forward" : "backward")
                            pointArray.append(nextIntersection)
                        }
                    }
                }
            }
        }
        
        let newRegions = newRegionIntersectionArrays.map { (intersections) -> Region in
            return Region(points: intersections.map({ (intersection) -> CGPoint in
                guard let line = intersection.selfLine else { return .zero }
                let deltaX = line.end.x - line.start.x
                let x = line.start.x + intersection.point * deltaX
                let deltaY = line.end.y - line.start.y
                let y = line.start.y + intersection.point * deltaY
                return CGPoint(x: x, y: y)
            }))
        }
        
        self.lines.append(line)
        
        return newRegions
    }
    
    // MARK: - private variables
    
    private var lines = [Line]()
    
    // MARK: - private functions
    
    private func getIndex(for line: Line, in intersectionsToSearchIn: SortedArray<Intersection>?) -> Int? {
        guard let intersectionsToSearchIn = intersectionsToSearchIn else { return nil }
        for intersection in intersectionsToSearchIn {
            if intersection.line === line {
                return intersectionsToSearchIn.anyIndex(of: intersection)
            }
        }
        return nil
    }
}
