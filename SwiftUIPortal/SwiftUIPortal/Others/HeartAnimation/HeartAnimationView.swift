//
//  HeartAnimationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 10/12/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct HeartAnimationView: View {
    
    /// View properties
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulseHearts: [HeartParticle] = []
    
    @State private var heartBeat: Int = 85
    var body: some View {
        VStack {
            ZStack {
                if showPulses {
                    TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeline in
                        // MARK: Method 2
                        ZStack {
                            /// Inserting into Canvas with Unique ID
                            ForEach(pulseHearts) { _ in
                                PulseHeartView()
                            }
                            
                        }
                        .onChange(of: timeline.date) { oldValue, newValue in
                            if beatAnimation {
                                addPulsedHeart()
                            }
                        }
                        
                        // MARK: Method 1
//                        Canvas { context, size in
//                            /// Drawing into the Canvas
//                            for heart in pulseHearts {
//                                if let resolvedView = context.resolveSymbol(id: heart.id) {
//                                    let centerX = size.width/2
//                                    let centerY = size.height/2
//                                    context.draw(resolvedView, at: CGPoint(x: centerX, y: centerY))
//                                }
//                            }
//                        } symbols: {
//                            /// Inserting into Canvas with Unique ID
//                            ForEach(pulseHearts) {
//                                PulseHeartView()
//                                    .id($0.id)
//                            }
//                        }
//                        .onChange(of: timeline.date) { oldValue, newValue in
//                            if beatAnimation {
//                                addPulsedHeart()
//                            }
//                        }
                    }
                }
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(Color("Heart", bundle: nil).gradient)
                    .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
            }
            .frame(maxWidth: 350, maxHeight: 350)
            .overlay(alignment: .bottomLeading, content: {
                VStack(alignment: .leading, spacing: 5, content: {
                    Text("Current")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    
                    HStack(alignment: .bottom, spacing: 6) {
                        TimelineView(.animation(minimumInterval: 1.5, paused: false)) { timeline in
                            Text("\(heartBeat)")
                                .font(.system(size: 45).bold())
                                .contentTransition(.numericText(value: Double(heartBeat)))
                                .foregroundStyle(.white)
                                .onChange(of: timeline.date) { oldValue, newValue in
                                    if beatAnimation {
                                        withAnimation(.bouncy) {
                                            heartBeat = .random(in: 80...130)
                                        }
                                    }
                                }
                        }
                        Text("BPM")
                            .font(.callout.bold())
                            .foregroundStyle(Color("Heart", bundle: nil).gradient)
                    }
                    
                    Text("88 BPM, 10m ago")
                        .font(.callout)
                        .foregroundStyle(.gray)
                })
                .offset(x: 30, y: -35)
            })
            .background(.bar, in: .rect(cornerRadius: 30))
            
            Toggle("Beat animation", isOn: $beatAnimation)
                .padding(15)
                .frame(maxWidth: 350)
                .background(.bar, in: .rect(cornerRadius: 15))
                .padding(.top, 20)
                .onChange(of: beatAnimation) { oldValue, newValue in
                    if pulseHearts.isEmpty {
                        showPulses = true
                    }
                    if newValue && pulseHearts.isEmpty {
                        /// For the first bounce, the pulsed heart view is not adding up. We can solve this by simply adding a pulsed heart  view immediately after the pulse view is toggled
                        showPulses = true
                        addPulsedHeart()
                    }
                }
                .disabled(!beatAnimation && !pulseHearts.isEmpty)
        }
    }
    
    func addPulsedHeart() {
        let pulsedHeart = HeartParticle()
        pulseHearts.append(pulsedHeart)
        
        /// Removing after the pulse animation was finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulseHearts.removeAll(where: { $0.id == pulsedHeart.id })
            
            if pulseHearts.isEmpty {
                showPulses = false
            }
        }
    }
}

/// Pulsed Heart Animation
struct PulseHeartView: View {
    @State private var startAnimation: Bool = false
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 100))
            .foregroundStyle(Color("Heart", bundle: nil))
            .background(content: {
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.black)
                    .blur(radius: 5, opaque: false)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.0), value: startAnimation)
            })
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 0.7)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

@available(iOS 17.0, *)
#Preview() {
    HeartAnimationView()
            .preferredColorScheme(.dark)
}
