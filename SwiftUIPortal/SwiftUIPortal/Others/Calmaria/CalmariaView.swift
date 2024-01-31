//
//  CalmariaView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 23/01/2024.
//

import SwiftUI

struct CalmariaView: View {
    
    @State private var scale: CGFloat = 0.5
    
    @State private var time: Int = 0
    @State private var round: Int = 0
    @State private var remainingTime: Int = 0
    @State private var isTimerRunning: Bool = false
    
    @State private var timer: Timer?
    
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ZStack {
                    /// Circles that animated
                    Circle()
                        .fill(LinearGradient(colors: [Color.yellow, Color.orange, Color.red, Color.pink], startPoint: .top, endPoint: .bottom))
                        .padding()
                        .scaleEffect(scale)
                        .onTapGesture {
                            if timer != nil {
                                timer?.invalidate()
                                timer = nil
                                remainingTime = 0
                                withAnimation(.snappy) {
                                    self.scale = Double(0.5)
                                }
                                
                                return
                            }
                            startTimer(4, 1)
                        }
                    
                    /// Half circle to create blur effect
                    Circle()
                        .trim(from: 0, to: 0.5)
                        .fill(LinearGradient(colors: [Color.yellow, Color.orange, Color.red, Color.pink], startPoint: .top, endPoint: .bottom))
                        .blur(radius: 30)
                        .padding()
                        .scaleEffect(scale)
                    
                    
                    VStack {
                        Spacer()
                        
                        CalmariaVisualEffectView(effect: UIBlurEffect(style: .dark))
                            .ignoresSafeArea(edges: .all)
                            .frame(height: proxy.size.height / 2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    overlay
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
    
    /// Overlay layout design
    var overlay: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Focus/\nBreathe/\nRelax/")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(round.numbers())")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            HStack(alignment: .bottom) {
                Text("Tap\nCircle\nto Start")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(remainingTime.numbers())")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
        }
        .padding()
        .foregroundStyle(.white)
        
    }
    
    /// Now create a function for timer that animate circle
    func startTimer(_ num: Int, _ scale: Float) {
        remainingTime = num
        
        withAnimation(.easeIn(duration: TimeInterval(num))) {
            self.scale = Double(scale)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                timer = nil
                /// Add cases for inHeal Hold Exale and Hole again
                switch num {
                    case 4:
                        startTimer(7, 1)
                    case 7:
                        startTimer(8, 0.5)
                    case 8:
                        round += 1
                        startTimer(4, 1)
                    default:
                        startTimer(0, 0)
                }
            }
        })
    }
}

private extension Int {
    func numbers() -> String {
        return String(format: "%02d", self)
    }
}


#Preview {
    CalmariaView()
}
