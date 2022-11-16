//
//  CircularProgressBarBackgroundView.swift
//  SwiftUIPortal
//
//  Created by Dylan on 14/11/2022.
//

import SwiftUI

struct CircularProgressBarBackgroundView: View {
    let total: Int
    @State var lineWidth: CGFloat = 16
    var shortDashSize: CGFloat { 1 }
    func longDashSize(circleWidth: CGFloat) -> CGFloat {
        .pi * circleWidth / CGFloat(total) - shortDashSize
    }
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .stroke(Color(white: 230/255),
                        style: StrokeStyle(
                            lineWidth: lineWidth / 1.6,
                            lineCap: .butt,
                            lineJoin: .miter,
                            miterLimit: 0,
                            dash: [
                                longDashSize(circleWidth: geometry.size.width),
                                shortDashSize
                            ],
                            dashPhase: 0))
                .rotationEffect(.degrees(-90))
        }
        .padding(lineWidth/2)
    }
}
