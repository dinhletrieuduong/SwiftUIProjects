//
//  CircleTimerView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 22/02/2024.
//

import SwiftUI
import ActivityKit

struct CircleTimerView: View {
    
    @Binding var progress: Double
    @Binding var duration: TimeInterval
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.08)
                .foregroundColor(.black)
                .frame(width: 200, height: 200)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270.0))
                .foregroundColor(Color.primary)
                .frame(width: 200, height: 200)
        }
        
        Text(duration.format(using: [.minute, .second]))
            .font(.title2.bold())
            .foregroundColor(Color.gray)
            .contentTransition(.numericText())
    }
}

struct CircleTimerDemoView: View {
    // Boolean indicates wether the timer is running or not.
    @State var isTimerRunning = false
    @State var startTime = Date()
    
    // The interval difference between total and remaining duration.
    @State var interval = TimeInterval()
    
    // The actual total duration.
    @State var totalDuration: TimeInterval = 2 * 60
    
    // The remaining duration.
    @State var duration: TimeInterval = 2 * 60
    
    // Timer progress.
    @State var progress = 1.0
    
    // Timer which will publish update every one second.
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var activity: Activity<TimerAttributes>?
    
    var body: some View {
        VStack {
            Spacer()
            
            if isTimerRunning {
                CircleTimerView(progress: $progress, duration: $duration)
                    .onReceive(timer) { time in
                        if (isTimerRunning) {
                            interval = Date().timeIntervalSince(startTime)
                            duration = totalDuration - interval
                            progress = (duration / totalDuration)
                            // Stop timer when it finishes counting down.
                            if duration <= 0 {
                                stopTimer()
                            } else {
                                guard let id = activity?.id else { return }
                                LiveActivityManager().updateActivity(
                                    activity: id,
                                    duration: duration,
                                    progress: progress
                                )
                            }
                        }
                    }
            }
            
            Spacer()
            
            HStack(spacing: 24) {
                Button {
                    startTime = Date()
                    startTimer()
                } label: {
                    Text("Start")
                    Image(systemName: "stopwatch")
                }
                .timerButtonStyle(isValid: !isTimerRunning)
                .disabled(isTimerRunning)
                
                Button {
                    stopTimer()
                } label: {
                    Text("Stop")
                    Image(systemName: "stop.circle")
                }
                .timerButtonStyle(isValid: isTimerRunning)
                .disabled(!isTimerRunning)
            }
        }
        .padding()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        activity = LiveActivityManager().startActivity(duration: duration, progress: progress)
        isTimerRunning.toggle()
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
        
        LiveActivityManager().endActivity()
        resetTimer()
        isTimerRunning.toggle()
    }
    
    func resetTimer() {
        totalDuration = 120
        duration = 120
        progress = 1.0
    }
}

#Preview(body: {
    CircleTimerDemoView()
})
