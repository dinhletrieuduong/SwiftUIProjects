//
//  CGPointExtension.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 9/8/24.
//

import CoreGraphics

extension CGPoint {
    /// Build a point from an origin and a displacement
    func displace(by point: CGPoint = .init(x: 0.0, y: 0.0)) -> CGPoint {
        return CGPoint(x: self.x+point.x,
                       y: self.y+point.y)
    }

    /// Caps the point to the unit space
    func capped() -> CGPoint {
        return CGPoint(x: max(min(x, 1), 0),
                       y: max(min(y, 1), 0))
    }
}
