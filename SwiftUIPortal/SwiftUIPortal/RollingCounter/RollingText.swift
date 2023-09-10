//
//  RollingText.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 02/09/2023.
//

import SwiftUI

struct RollingText: View {
    // MARK: Properties
    var font: Font = .largeTitle
    var weight: Font.Weight = .regular
    @Binding var value: Int
    var animationDuration: CGFloat = 0.15
    // MARK: Animation Properties
    @State var animationRange: [Int] = []
    
    var body: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<animationRange.count, id: \.self) { index in
                // MARK: To find text size for given font
                // Random number
                Text("8")
                    .font(font)
                    .fontWeight(weight)
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            VStack(spacing: 0, content: {
                                // MARK: Since its individual value
                                // Need from 0-9
                                ForEach(0...9, id: \.self) { number in
                                    Text("\(number)")
                                        .font(font)
                                        .fontWeight(weight)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            })
                            // MARK: Setting offset
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                        .clipped()
                    }
                
            }
        })
        .onAppear {
            // MARK: Loading Range
            animationRange = Array(repeating: 0, count: "\(value)".count)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText()
            }
        }
        .onChange(of: value) { newValue in
            // MARK: Handling addition/removal to extra value
            let extra = "\(value)".count - animationRange.count
            if extra > 0 {
                // Adding extra range
                for _ in 0..<extra {
                    withAnimation(.easeIn(duration: 0.1)) {
                        animationRange.append(0)
                    }
                }
            } else {
                // Remove extra range
                for _ in 0..<(-extra) {
                    let _ = withAnimation(.easeIn(duration: 0.1)) {
                        animationRange.removeLast()
                    }
                }
            }
            
            // MARK: Little delay for nice look
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText()
            }
        }
    }
    
    func updateText() {
        let stringValue = "\(value)"
        for (index, value) in zip(0..<stringValue.count, stringValue) {
            /// If first value = 1, then offset  will be applied for -1,
            /// So the text will move up to show 1 value
            // MARK: DampingFraction base on index value
            var fraction = Double(index) * 0.15
            // MAX = 0.5
            // Total = 1.5
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: animationDuration, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                animationRange[index] = (String(value) as NSString).integerValue
            }
        }
    }
}
