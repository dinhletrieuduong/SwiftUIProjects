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

extension Color {
    public static var outlineRed: Color {
        return Color(decimalRed: 34, green: 0, blue: 3)
    }
    
    public static var darkRed: Color {
        return Color(decimalRed: 221, green: 31, blue: 59)
    }
    
    public static var lightRed: Color {
        return Color(decimalRed: 239, green: 54, blue: 128)
    }
    
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}

#Preview {
    ZStack {
        Color.black
            .edgesIgnoringSafeArea(.all)
        ActivityRingView(progress: <#Binding<CGFloat>#>)
            .fixedSize()
    }
}
