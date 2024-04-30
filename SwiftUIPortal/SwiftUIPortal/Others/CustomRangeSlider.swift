//
//  CustomRangeSlider.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 29/04/2024.
//

import SwiftUI

struct DemoCustomRangeSlider: View {
    @State private var selection: ClosedRange<CGFloat> = 30...50
    var body: some View {
        VStack {
            CustomRangeSlider(selection: $selection, range: 10...100, minimumDistance: 5)
            
            Text("\(Int(selection.lowerBound)):\(Int(selection.upperBound))")
                .font(.largeTitle.bold())
                .padding(.top, 10)
        }
        .padding()
    }
}
struct CustomRangeSlider: View {
    @Binding var selection: ClosedRange<CGFloat>
    
    var range: ClosedRange<CGFloat>
    var minimumDistance: CGFloat = 0
    var tint: Color = .primary
    
    @State private var isInitial: Bool = false
    
    @State private var slider1: GestureProperties = .init()
    @State private var slider2: GestureProperties = .init()
    @State private var indicatorWidth: CGFloat = 0
    
    var body: some View {
        GeometryReader { reader in
            let size = reader.size
            let maxSliderWidth = size.width - 30
            let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(tint.tertiary)
                    .frame(height: 5)
                
                HStack(spacing: 0) {
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .overlay(alignment: .leading, content: {
                            Rectangle()
                                .fill(tint)
                                .offset(x: 15)
                                .frame(width: indicatorWidth, height: 4)
                                .allowsHitTesting(false)
                        })
                        .offset(x: slider1.offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    var translation = value.translation.width + slider1.lastStoredOffset
                                    translation = min(max(translation, 0), slider2.offset - minimumDistance)
                                    slider1.offset = translation
                                    
                                    calculateNewRange(size)
                                })
                                .onEnded({ _ in
                                    slider1.lastStoredOffset = slider1.offset
                                })
                        )
                    
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .offset(x: slider2.offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    var translation = value.translation.width + slider2.lastStoredOffset
                                    translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
                                    slider2.offset = translation
                                    
                                    calculateNewRange(size)
                                })
                                .onEnded({ _ in
                                    slider2.lastStoredOffset = slider2.offset
                                })
                        )
                }
            }
            .frame(maxHeight: .infinity)
            .task {
                guard !isInitial else { return }
                isInitial = true
                try? await Task.sleep(for: .seconds(0))
                
                /// Converting selection range
                let start = selection.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxSliderWidth])
                let end = selection.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxSliderWidth])
                
                slider1.offset = start
                slider1.lastStoredOffset = start
                
                slider2.offset = end
                slider2.lastStoredOffset = end
                
                calculateNewRange(size)
            }
        }
        .frame(height: 15)
    }
    
    private func calculateNewRange(_ size: CGSize) {
        indicatorWidth = slider2.offset - slider1.offset
        
        let maxWidth = size.width - 30
        let startProgress = slider1.offset/maxWidth
        let endProgress = slider2.offset/maxWidth
        
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
        
        selection = newRangeStart...newRangeEnd
    }
    
    private struct GestureProperties {
        var offset: CGFloat = 0
        var lastStoredOffset: CGFloat = 0
    }
}


#Preview {
    DemoCustomRangeSlider()
}

// Interpolation
private extension CGFloat {
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
        /// If value less than it's Initial input range
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return inputRange[0] }
        
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            
            /// Linear Interpolation formula:  y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
            if x <= x2 {
                let y = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
                return y
            }
        }
        
        /// If value exceeds it's maximum input range
        return outputRange[length]
    }
}
