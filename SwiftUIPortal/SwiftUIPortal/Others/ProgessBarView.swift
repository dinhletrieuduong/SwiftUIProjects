//
//  ProgessBarView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

let darkBlue = Color.blue
let lightGray = Color.gray

struct DashedHalvedCircularBar: View {
    
    @State var circleProgress: CGFloat
    var widthAndHeight: CGFloat
    var labelSize: CGFloat?
    var lineWidth: CGFloat?
    var staticColor: Color?
    var progressColor: Color
    var showLabel: Bool?
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(self.staticColor ?? Color.gray, style: .init( lineWidth: self.lineWidth ?? 12, dash: [8]))
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .rotationEffect(Angle(degrees: -180), anchor: .center)
                
                Circle()
                    .trim(from: 0, to: self.circleProgress/2)
                    .stroke(self.progressColor, lineWidth: self.lineWidth ?? 12)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .rotationEffect(Angle(degrees: -180))
                
                if self.showLabel ?? true {
                    Text("\(Int(self.circleProgress*100))%")
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .font(.custom("HelvetiacNeue", size: self.labelSize ?? 20.0))
                }
            }
            
        })
        .frame(width: widthAndHeight, height: widthAndHeight, alignment: .center)
        .onAppear(perform: {
            start()
        })
    }
    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            withAnimation {
                self.circleProgress += 0.01
            }
            if self.circleProgress >= 1 {
                timer.invalidate()
            } else {
            }
        })
    }
}

struct CircularProgressBase: View {
    @State var circleProgress: CGFloat
    var widthAndHeight: CGFloat
    var labelSize: CGFloat?
    var lineWidth: CGFloat?
    var staticColor: Color?
    var progressColor: Color
    var showLabel: Bool?
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Circle()
                    .stroke(self.staticColor ?? Color.gray, lineWidth: self.lineWidth ?? 15)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                
                Circle()
                    .trim(from: 0, to: self.circleProgress)
                    .stroke(self.progressColor, lineWidth: self.lineWidth ?? 15)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .rotationEffect(Angle(degrees: -90))
                if self.showLabel ?? true {
                    Text("\(Int(self.circleProgress*100))%")
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .font(.custom("HelvetiacNeue", size: self.labelSize ?? 20.0))
                }
            }
            
        })
        .frame(width: widthAndHeight, height: widthAndHeight, alignment: .center)
        .onAppear(perform: {
            start()
        })
    }
    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            withAnimation {
                self.circleProgress += 0.01
            }
            if self.circleProgress >= 1 {
                timer.invalidate()
            } else {
            }
        })
    }
}

struct ActivityIndicator: View {
    @State var degrees = 0.0
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.6)
            .stroke(darkBlue, lineWidth: 5)
            .frame(width: 120, height: 120, alignment: .center)
            .rotationEffect(Angle(degrees: degrees), anchor: .center)
            .onAppear(perform: {
                self.start()
            })
    }
    
    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { timer in
            withAnimation {
                self.degrees += 10.0
            }
            if self.degrees == 360 {
                self.degrees = 0.0
            }
        })
    }
}
