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

struct CircularProgressBarSampleView: View {
    
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    let total = 6
    @State var completed = 0
    let lineWidth: CGFloat = 16
    
    var body: some View {
        VStack {
            CircularProgressBarView(total: total, completed: completed, lineWidth: lineWidth, color: .green)
            Button {
                withAnimation {
                    guard completed < total else {
                        completed = 0
                        return
                    }
                    completed += 1
                }
            } label: {
                Text("Finish next step")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
            .padding(.vertical)
        }
        .padding()
    }
    
}
