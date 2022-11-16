//
//  CircularProgressBarView.swift
//  SwiftUIPortal
//
//  Created by Dylan on 14/11/2022.
//

import SwiftUI

struct CircularProgressBarView: View {
    let total: Int
    let completed: Int
    @State var lineWidth: CGFloat = 16
    @State var color: Color = .green
    
    var body: some View {
        ZStack {
            CircularProgressBarBackgroundView(total: total, lineWidth: lineWidth)
            CircularProgressBarProgressView(total: total, completed: completed, lineWidth: lineWidth, color: color)
        }
    }
}
struct CircularProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBarView(total: 6, completed: 4)
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
