//
//  ParallaxCarouselCardModel.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 26/01/2024.
//

import SwiftUI

struct ParallaxCarouselCardModel: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subtitle: String
    var image: String
}

var tripList: [ParallaxCarouselCardModel] = [
    .init(title: "Time Square", subtitle: "New York", image: "time-square"),
    .init(title: "Down Town", subtitle: "USA", image: "down-town"),
    .init(title: "Golden Bridge", subtitle: "USA", image: "golden-bridge"),
    .init(title: "London", subtitle: "England", image: "london"),
]
