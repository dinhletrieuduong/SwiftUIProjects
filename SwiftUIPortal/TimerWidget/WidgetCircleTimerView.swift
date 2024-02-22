//
//  WidgetCircleTimerView.swift
//  TimerWidgetExtension
//
//  Created by Dinh Le Trieu Duong on 22/02/2024.
//

import SwiftUI

struct WidgetCircleTimerView: View {

    var progress: Double
    var duration: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.25)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270.0))
                .foregroundColor(Color.accentColor)
                .frame(width: 36, height: 36)
        }
    }
}

struct LiveActivityView: View {
    let state: TimerAttributes.ContentState
    
    var body: some View {
        HStack {
            Button {
                //TODO: End the activity
            } label: {
                Label("Stop", systemImage: "stop.circle")
                    .font(.body.bold())
            }
            .foregroundColor(Color.white)
            .background(Color.primary)
            .clipShape(Capsule())
            .padding(.horizontal)
            .padding(.vertical, 8)
            .transition(.identity)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 16) {
                WidgetCircleTimerView(
                    progress: state.progress,
                    duration: state.duration
                )
                
                Text(state.duration)
                    .font(.largeTitle.monospacedDigit())
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText())
            }
        }
        .id(state)
        .padding()
        .foregroundColor(Color.accentColor)
    }
}
