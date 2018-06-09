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
    private var lines = [Line]()
    
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
                    switch (currentIntersection.isRightHanded, currentIntersection.isForward) {
                    case (true, true):
                        if currentLine.lhsForwardAngle - .pi < nextLine.rhsForwardAngle, currentLine.lhsForwardAngle > nextLine.lhsForwardAngle {
                            nextIndex += 1
                        } else {
                            nextIndex -= 1
                            isForward = false
                        }
                    case (true, false):
                        if currentLine.lhsBackwardAngle - .pi < nextLine.rhsForwardAngle, currentLine.lhsBackwardAngle > nextLine.lhsForwardAngle {
                            nextIndex += 1
                        } else {
                            nextIndex -= 1
                            isForward = false
                        }
                    case (false, true):
                        if currentLine.rhsForwardAngle + .pi > nextLine.rhsForwardAngle, currentLine.rhsForwardAngle < nextLine.lhsForwardAngle {
                            nextIndex += 1
                        } else {
                            nextIndex -= 1
                            isForward = false
                        }
                    case (false, false):
                        if currentLine.rhsBackwardAngle + .pi > nextLine.rhsForwardAngle, currentLine.rhsBackwardAngle < nextLine.lhsForwardAngle {
                            nextIndex += 1
                        } else {
                            nextIndex -= 1
                            isForward = false
                        }
                    }
                    
                    if nextLine.intersections.indices.contains(nextIndex) {
                        nextIntersection = nextLine.intersections[nextIndex]
                        nextIntersection?.isRightHanded = isRightHanded
                        nextIntersection?.isForward = isForward
                    } else {
                        while pointArray.last?.isRightHanded == !isRightHanded {
                            pointArray.removeLast()
                        }
                        if pointArray.count <= 2 {
                            break
                        }
                        pointArray.last?.isRightHanded = !isRightHanded
                    }
                    
                    if let nextIntersection = nextIntersection {
                        if firstIntersection.line === nextIntersection.selfLine && firstIntersection.selfLine === nextIntersection.line {
                            newRegionIntersectionArrays.append(pointArray)
                            break
                        } else {
                            if pointArray.contains(nextIntersection) {
                                break
                            }
                            print(nextIntersection.isForward ? "forward" : "backward")
                            pointArray.append(nextIntersection)
                        }
                    }
                }
            }
        }
        
//        let newRegions = [Region(points: [CGPoint(x: 10, y: 10),CGPoint(x: 10, y: 100),CGPoint(x: 100, y: 100),CGPoint(x: 100, y: 10)])]
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
