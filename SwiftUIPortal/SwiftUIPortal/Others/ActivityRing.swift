//
//  ActivityRing.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 31/01/2024.
//

import SwiftUI
struct ActivityRingView: View {
    @Binding var progress: CGFloat
    
    var colors: [Color] = [Color.darkRed, Color.lightRed]
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.outlineRed, lineWidth: 20)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                ).rotationEffect(.degrees(-90))
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.darkRed)
                .offset(y: -150)
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(progress > 0.95 ? Color.lightRed: Color.lightRed.opacity(0))
                .offset(y: -150)
                .rotationEffect(Angle.degrees(360 * Double(progress)))
                .shadow(color: progress > 0.96 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
        }.frame(idealWidth: 300, idealHeight: 300, alignment: .center)
    }
}

struct ActivityRingContentView: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ActivityRingView(progress: $progress)
                .fixedSize()

        }
        .onAppear(perform: {
            withAnimation(.spring(response: 5, dampingFraction: 1.0, blendDuration: 1.0)) {
//            withAnimation(.smooth(duration: 5)) {
                progress = 1
            }
        })
    }
}
//There are still improvements you can make upon this, e.g., make .offset dynamic with the frame (currently it hard code to 150), pack three rings to make an identical as Apple Activity ring, or make the ring supports progress more than 1.
//
//I encourage you to implement those improvements yourself. I may write a follow-up of this article to cover those things.

struct RingProgressBar: View {
    
    @Binding var animateTheRings: Bool
    
    @Binding var progressValueOne: CGFloat
    @Binding var progressValueTwo: CGFloat
    @Binding var progressValueThree: CGFloat
    
    let strawberry = Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))
    let lime = Color(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1))
    let ice = Color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1))
    
    let animation = Animation.easeOut(duration: 3)
    
    var body: some View {
        ZStack {
            Color.black
            ring(for: strawberry, progress: progressValueOne)
                .frame(width: 165)
            ring(for: lime, progress: progressValueTwo)
                .frame(width: 128)
            ring(for: ice, progress: progressValueThree)
                .frame(width: 92)
        }
        .animation(animation, value: animateTheRings)
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder
    private func ring(for color: Color, progress value: CGFloat) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 16))
            .foregroundStyle(.tertiary)
            .overlay {
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(color.gradient, style: StrokeStyle(lineWidth: 16, lineCap: .round))
            }
            .rotationEffect(.degrees(-90))
    }
    
}

struct RingProgressBarDemo: View {
    @State private var animateTheRings: Bool = true
    @State private var progressValueOne: CGFloat = 0.4
    @State private var progressValueTwo: CGFloat = 0.5
    @State private var progressValueThree: CGFloat = 0.8
    var body: some View {
        RingProgressBar(animateTheRings: $animateTheRings, progressValueOne: $progressValueOne, progressValueTwo: $progressValueTwo, progressValueThree: $progressValueThree)
    }
}

#Preview {
    RingProgressBarDemo()
//    ActivityRingContentView()
}


private extension Color {
    static var outlineRed: Color {
        return Color(decimalRed: 34, green: 0, blue: 3)
    }
    
    static var darkRed: Color {
        return Color(decimalRed: 221, green: 31, blue: 59)
    }
    
    static var lightRed: Color {
        return Color(decimalRed: 239, green: 54, blue: 128)
    }
    
    init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}
