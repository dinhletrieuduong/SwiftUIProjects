//
//  TimerWithCombine.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 17/11/2021.
//


import SwiftUI
import Combine

struct TimerWithCombine: View {
    
    @ObservedObject var counter = Counter(from: 10, to: 1)
    
    @State private var timeUp = false
    
    var body: some View {
        ZStack {
            if timeUp {
                Text("Time Up")
            }
            else {
                Text("\(counter.currentCount)")
                    .font(Font.custom("menlo", size: 100))
                    .foregroundColor(colorForIndex(index: counter.currentCount))
                    .onAppear { counter.count {
                        timeUp = true
                    }}
                ProgressCircle(startPosition: .top, lineWidth: 5, fadedColor: .green, color: .green, animationDuration: Double(counter.currentCount))
                    .frame(width: 300, height: 300)
            }
        }
    }
    
    private func colorForIndex(index: Int) -> Color {
        switch index {
            case 0...3:
                return Color.red
            case 4...5:
                return Color.orange
            default:
                return Color.green
        }
    }
    
        // MARK:- CONSTANTS
    private let colors = [Color.pink, Color.yellow, Color.purple, Color.blue, Color.green]
    
}


struct Combine_Previews: PreviewProvider {
    static var previews: some View {
        TimerWithCombine()
    }
}
