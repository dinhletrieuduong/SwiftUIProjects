//
//  DownloadingView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

struct DownloadingView: View {
    @State var loadingProgress: CGFloat = 0.0
    
    let gradient = [Color.orange, Color.yellow, Color.orange]
    
    @State var startPoint = UnitPoint(x: -1, y: 0)
    @State var endPoint = UnitPoint(x: 0, y: 0)
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(width: 320, height: 15, alignment: .center)
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: gradient), startPoint: startPoint, endPoint: endPoint))
                .frame(width: 320 * loadingProgress, height: 15, alignment: .center)
        }
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 1).repeatCount(1, autoreverses: false)) {
                startPoint = UnitPoint(x: 1, y: 0)
                endPoint = UnitPoint(x: 2, y: 0)
            }
            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                if loadingProgress <= 1 {
                    withAnimation {
                        loadingProgress += 0.01
                    }
                }
            }
        })
    }
}
