//
//  ParticleModel.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 31/12/2023.
//

import SwiftUI

struct Particle: Identifiable {
    var id: UUID = .init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1
    /// Optional
    var opacity: CGFloat = 1
    
    /// Reset's all properties
    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
    }
}
