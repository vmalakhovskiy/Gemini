//
//  NSBezierPathExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import Cocoa

extension NSBezierPath {

    var CGPath: CGPathRef {
        get {
            return transformToCGPath()
        }
    }

    private func transformToCGPath() -> CGPathRef {
        let path = CGPathCreateMutable()
        let points = UnsafeMutablePointer<NSPoint>.alloc(3)
        let numElements = elementCount

        if numElements > 0 {
            var didClosePath = true
            for index in 0..<numElements {

                let pathType = elementAtIndex(index, associatedPoints: points)
                switch pathType {
                case .MoveToBezierPathElement:
                    CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
                case .LineToBezierPathElement:
                    CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
                    didClosePath = false
                case .CurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
                    didClosePath = false
                case .ClosePathBezierPathElement:
                    CGPathCloseSubpath(path)
                    didClosePath = true
                }
            }

            if !didClosePath {
                CGPathCloseSubpath(path)
            }
        }

        points.dealloc(3)
        return path
    }
}