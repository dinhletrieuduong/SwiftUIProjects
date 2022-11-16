//
//  CircularProgressBarProgressView.swift
//  SwiftUIPortal
//
//  Created by Dylan on 14/11/2022.
//

import SwiftUI

struct CircularProgressBarProgressView: View {
    let total: Int
    let completed: Int
    @State var lineWidth: CGFloat = 16
    @State var color: Color = .green
    var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(completed)/CGFloat(total))
            .stroke(color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    ))
            .rotationEffect(.degrees(-90))
            .padding(lineWidth/2)
    }
}
struct CircularProgressBarProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircularProgressBarProgressView(total: 6, completed: 0)
            CircularProgressBarProgressView(total: 6, completed: 4)
            CircularProgressBarProgressView(total: 6, completed: 6)
        }
        .previewLayout(.fixed(width: 400, height: 400))
    }
}
