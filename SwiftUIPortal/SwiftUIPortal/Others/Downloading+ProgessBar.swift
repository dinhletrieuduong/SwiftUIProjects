//
//  DownloadingView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

struct DownloadingDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0, content: {
                DownloadingView()
                
                DashedHalvedCircularBar(circleProgress: 0.01, widthAndHeight: 300, progressColor: .blue)
                    .padding(.top, 40)
                
                ActivityIndicator()
                    .offset(y: -80)
                
                CircularProgressBase(circleProgress: 0.01, widthAndHeight: 100, labelSize: 15, lineWidth: 15, staticColor: .black, progressColor: .blue, showLabel: true)
                    
                CircularProgressBarSampleView()
                
            })
            .padding()
        }
    }
}

#Preview {
    DownloadingDemoView()
}

// MARK: DownloadingView
struct DownloadingView: View {
    @State var loadingProgress: CGFloat = 0.0
    
    let gradient = [Color.orange, Color.yellow, Color.orange]
    
    @State var startPoint = UnitPoint(x: -1, y: 0)
    @State var endPoint = UnitPoint(x: 0, y: 0)
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(width: 320, height: 15, alignment: .center)
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: gradient), startPoint: startPoint, endPoint: endPoint))
                .frame(width: 320 * loadingProgress, height: 15, alignment: .center)
        }
        .onAppear(perform: {
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.easeInOut(duration: 1).repeatCount(1, autoreverses: false)) {
                    startPoint = UnitPoint(x: 1, y: 0)
                    endPoint = UnitPoint(x: 2, y: 0)
                }
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                    if loadingProgress <= 1 {
                        withAnimation {
                            loadingProgress += 0.01
                        }
                    }
                }
            }
        })
    }
}

let darkBlue = Color.blue
let lightGray = Color.gray

// MARK: DashedHalvedCircularBar
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

// MARK: CircularProgressBase
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

// MARK: ActivityIndicator
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
