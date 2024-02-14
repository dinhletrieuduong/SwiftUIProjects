//
//  GitHubAnimationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 12/02/2024.
//

import SwiftUI

struct GitHubAnimationView: View {
    var body: some View {
        CatView()
            .preferredColorScheme(.dark)
        
    }
}

struct CatView: View {
    
    @State private var resetStrokes: Bool = true
    @State private var winkLeft: Bool = false
    
    @State private var strokeStart: CGFloat = 0
    @State private var strokeEnd: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let cX: CGFloat = $0.frame(in: .global).midX
            let cY: CGFloat = $0.frame(in: .global).midY
            
            ZStack {
//                Color("ThemeBG")
                Color.black
                    .ignoresSafeArea()
                ZStack {
                    CatShape()
                        .trim(from: 0, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round, miterLimit: 8))
                        .scaleEffect(1.35)
                        .foregroundStyle(Color(.gray).opacity(0.15))
                        .shadow(color: .white.opacity(0.075), radius: 5, y: 2)
                    
                    CatShape()
                        .trim(from: strokeStart, to: strokeEnd)
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round, miterLimit: 8))
                        .scaleEffect(1.35)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5, y: 1)
                    
                    CatHead()
                        .scaleEffect(0.3925)
                        .opacity(0.3)
                        .offset(x: 3)
                        
                    Path({ path in
                        path.move(to: .init(x: cX + -66.14, y: cY + -14.34))
                        path.addCurve(to: .init(x: cX + -80.6, y: cY + 7.17), control1: .init(x: cX + -73.81, y: cY + -13.04), control2: .init(x: cX + -79.51, y: cY + -4.54))
                        path.addCurve(to: .init(x: cX + -69.38, y: cY + 34.62), control1: .init(x: cX + -81.76, y: cY + 19.57), control2: .init(x: cX + -77.08, y: cY + 30.95))
                        path.addCurve(to: .init(x: cX + -63.92, y: cY + 35.56), control1: .init(x: cX + -67.53, y: cY + 35.5), control2: .init(x: cX + -67.2, y: cY + 35.56))
                        path.addCurve(to: .init(x: cX + -58.4, y: cY + 34.56), control1: .init(x: cX + -60.58, y: cY + 35.56), control2: .init(x: cX + -60.34, y: cY + 35.5))
                        path.addCurve(to: .init(x: cX + -54.4, y: cY + -10.21), control1: .init(x: cX + -45.63, y: cY + 28.34), control2: .init(x: cX + -43.2, y: cY + 1.07))
                        path.addLine(to: .init(x: cX + -54.34, y: cY + -10.15))
                        
                        path.addCurve(to: .init(x: cX + -61.29, y: cY + -14.16), control1: .init(x: cX + -56.18, y: cY + -12.19), control2: .init(x: cX + -58.61, y: cY + -13.59))
                        path.addLine(to: .init(x: cX + -61.33, y: cY + -14.16))
                        
                        path.addCurve(to: .init(x: cX + -66, y: cY + -14.37), control1: .init(x: cX + -62.84, y: cY + -14.63), control2: .init(x: cX + -64.45, y: cY + -14.7))
                        path.addLine(to: .init(x: cX + -66.13, y: cY + -14.34))
                        
                        path.closeSubpath()
                    })
                    .scaleEffect(0.3925)
                    .foregroundStyle(.black)
                    .offset(y: -30)
                    .scaleEffect(.init(width: 1.0, height: resetStrokes ? 1 : winkLeft ? 0.225 : 1))
                    .animation(.easeInOut(duration: 0.3))
                    
                    
                    Path({ path in
                        path.move(to: .init(x: cX + 66.87, y: cY + -14.34))
                        path.addCurve(to: .init(x: cX + 52.4, y: cY + 7.17), control1: .init(x: cX + 59.19, y: cY + -13.04), control2: .init(x: cX + 53.49, y: cY + -4.54))
                        path.addCurve(to: .init(x: cX + 63.62, y: cY + 34.62), control1: .init(x: cX + 51.24, y: cY + 19.57), control2: .init(x: cX + 55.92, y: cY + 30.95))
                        path.addCurve(to: .init(x: cX + 69.08, y: cY + 35.56), control1: .init(x: cX + 65.47, y: cY + 35.5), control2: .init(x: cX + 65.8, y: cY + 35.56))
                        path.addCurve(to: .init(x: cX + 74.6, y: cY + 34.56), control1: .init(x: cX + 72.42, y: cY + 35.56), control2: .init(x: cX + 72.66, y: cY + 35.5))
                        path.addCurve(to: .init(x: cX + 78.6, y: cY + -10.21), control1: .init(x: cX + 87.37, y: cY + 28.34), control2: .init(x: cX + 89.8, y: cY + 1.07))
                        path.addLine(to: .init(x: cX + 78.66, y: cY + -10.15))
                        
                        path.addCurve(to: .init(x: cX + 71.71, y: cY + -14.16), control1: .init(x: cX + 76.82, y: cY + -12.19), control2: .init(x: cX + 74.39, y: cY + -13.59))
                        path.addLine(to: .init(x: cX + 71.67, y: cY + -14.16))
                        
                        path.addCurve(to: .init(x: cX + 67, y: cY + -14.37), control1: .init(x: cX + 70.16, y: cY + -14.63), control2: .init(x: cX + 68.55, y: cY + -14.7))
                        path.addLine(to: .init(x: cX + 66.87, y: cY + -14.34))
                        
                        path.closeSubpath()
                    })
                    .scaleEffect(0.3925)
                    .foregroundStyle(.black)
                    .offset(y: -30)
                    .scaleEffect(.init(width: 1.0, height: resetStrokes ? 1 : winkLeft ? 0.225 : 1))
                    .animation(.easeInOut(duration: 0.3))
                    
                }
                .scaleEffect(1.5)
                .offset(y: -42)
            }
            .onAppear(perform: {
                Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
                    withAnimation(.easeOut(duration: 0.55)) {
                        self.strokeEnd += CGFloat.random(in: 0.075 ..< 0.115)
                        self.strokeStart = self.strokeEnd - 0.25
                    }
                    if self.strokeEnd >= 1 {
                        if self.resetStrokes {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                self.strokeEnd = 0
                                self.strokeStart = 0
                                self.resetStrokes.toggle()
                                self.winkLeft = Bool.random()
                            }
                            self.resetStrokes = false
                        }
                    }
                }
            })
        }
    }
}

struct CatShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX
        let cY: CGFloat = rect.midY
     
        var path = Path()
        
        path.move(to: .init(x: cX + 24.07, y: cY + 77.5))
        
        /// MARK: Right
        path.addLine(to: .init(x: cX + 24.07, y: cY + 52.94))
        path.addLine(to: .init(x: cX + 24.06, y: cY + 53.12))
        
        path.addCurve(to: .init(x: cX + 18.14, y: cY + 36.4), control1: .init(x: cX + 24.6, y: cY + 46.95), control2: .init(x: cX + 22.44, y: cY + 40.85))
        path.addCurve(to: .init(x: cX + 58.99, y: cY + -8.06), control1: .init(x: cX + 38.04, y: cY + 34.15), control2: .init(x: cX + 58.99, y: cY + 26.6))
        path.addLine(to: .init(x: cX + 58.99, y: cY + -8.06))
        
        path.addCurve(to: .init(x: cX + 49.3, y: cY + -32.04), control1: .init(x: cX + 58.99, y: cY + -17), control2: .init(x: cX + 55.52, y: cY + -25.6))
        path.addLine(to: .init(x: cX + 49.56, y: cY + -32.1))
        
        path.addCurve(to: .init(x: cX + 48.72, y: cY + -56.2), control1: .init(x: cX + 52.41, y: cY + -39.94), control2: .init(x: cX + 52.11, y: cY + -48.58))
        path.addCurve(to: .init(x: cX + 24.08, y: cY + -46.4), control1: .init(x: cX + 48.9, y: cY + -55.79), control2: .init(x: cX + 41.41, y: cY + -58.02))
        path.addLine(to: .init(x: cX + 23.84, y: cY + -46.46))
        
        /// MARK: Top
        path.addCurve(to: .init(x: cX + -20.12, y: cY + -46.46), control1: .init(x: cX + 9.44, y: cY + -50.32), control2: .init(x: cX + -5.72, y: cY + -50.32))
        
        /// MARK: Left
        path.addCurve(to: .init(x: cX + -45.17, y: cY + -55.79), control1: .init(x: cX + -37.69, y: cY + -58.01), control2: .init(x: cX + -45.11, y: cY + -55.79))
        path.addLine(to: .init(x: cX + -45.22, y: cY + -55.69))
        
        path.addCurve(to: .init(x: cX + -45.64, y: cY + -31.58), control1: .init(x: cX + -48.48, y: cY + -48.01), control2: .init(x: cX + -48.63, y: cY + -39.37))
        path.addLine(to: .init(x: cX + -45.58, y: cY + -32.04))
        
        path.addCurve(to: .init(x: cX + -55.27, y: cY + -8.05), control1: .init(x: cX + -51.79, y: cY + -25.6), control2: .init(x: cX + -55.27, y: cY + -17))
        path.addCurve(to: .init(x: cX + -14.39, y: cY + 36.56), control1: .init(x: cX + -55.27, y: cY + 26.53), control2: .init(x: cX + -34.32, y: cY + 34.09))
        path.addLine(to: .init(x: cX + -14.4, y: cY + 36.58))
        
        path.addCurve(to: .init(x: cX + -20.36, y: cY + 52.93), control1: .init(x: cX + -18.62, y: cY + 40.94), control2: .init(x: cX + -20.78, y: cY + 46.88))
        path.addLine(to: .init(x: cX + -20.36, y: cY + 77.5))
        
        /// MARK: Tail
        path.move(to: .init(x: cX + -20.36, y: cY + 58.46))
        path.addCurve(to: .init(x: cX + -64.79, y: cY + 39.42), control1: .init(x: cX + -52.09, y: cY + 67.98), control2: .init(x: cX + -52.09, y: cY + 42.59))
        
//        path.closeSubpath()
        return path
    }
}

struct CatHead: Shape {
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX
        let cY: CGFloat = rect.midY
        
        var path = Path()
        path.move(to: .init(x: cX + -41.87, y: cY + -63.23))
        path.addCurve(to: .init(x: cX + 43.23, y: cY + -63.46), control1: .init(x: cX + -7.92, y: cY + -60.68), control2: .init(x: cX + 7.6, y: cY + -60.73))
        path.addCurve(to: .init(x: cX + 87.78, y: cY + -63.5), control1: .init(x: cX + 57.7, y: cY + -64.55), control2: .init(x: cX + 81.18, y: cY + -64.59))
        path.addCurve(to: .init(x: cX + 122, y: cY + -46.71), control1: .init(x: cX + 103.39, y: cY + -61), control2: .init(x: cX + 112.85, y: cY + -56.31))
        path.addLine(to: .init(x: cX + 122.28, y: cY + -46.42))
        
        path.addCurve(to: .init(x: cX + 139.09, y: cY + -14.8), control1: .init(x: cX + 130.74, y: cY + -37.66), control2: .init(x: cX + 136.56, y: cY + -26.71))
        path.addCurve(to: .init(x: cX + 139.75, y: cY + 13.04), control1: .init(x: cX + 140.43, y: cY + -8.71), control2: .init(x: cX + 140.7, y: cY + 4.67))
        path.addCurve(to: .init(x: cX + 119.68, y: cY + 58.59), control1: .init(x: cX + 137.38, y: cY + 33.15), control2: .init(x: cX + 131.33, y: cY + 46.94))
        path.addCurve(to: .init(x: cX + 46.64, y: cY + 85.85), control1: .init(x: cX + 104.53, y: cY + 73.75), control2: .init(x: cX + 81.32, y: cY + 82.44))
        path.addCurve(to: .init(x: cX + -0, y: cY + 87.63), control1: .init(x: cX + 32.08, y: cY + 87.31), control2: .init(x: cX + 23.53, y: cY + 87.63))
        path.addCurve(to: .init(x: cX + -47.87, y: cY + 85.85), control1: .init(x: cX + -23.71, y: cY + 87.63), control2: .init(x: cX + -33.54, y: cY + 87.26))
        path.addCurve(to: .init(x: cX + -141.76, y: cY + 12.5), control1: .init(x: cX + -108.09, y: cY + 79.8), control2: .init(x: cX + -136.94, y: cY + 57.27))
        path.addCurve(to: .init(x: cX + -140.94, y: cY + -15.4), control1: .init(x: cX + -142.58, y: cY + 5.04), control2: .init(x: cX + -142.12, y: cY + -10.34))
        path.addLine(to: .init(x: cX + -140.89, y: cY + -15.61))
        
        path.addCurve(to: .init(x: cX + -131.37, y: cY + -37.52), control1: .init(x: cX + -139.09, y: cY + -23.44), control2: .init(x: cX + -135.86, y: cY + -30.86))
        path.addCurve(to: .init(x: cX + -113.96, y: cY + -55.13), control1: .init(x: cX + -127.56, y: cY + -43.34), control2: .init(x: cX + -118.87, y: cY + -52.13))
        path.addCurve(to: .init(x: cX + -87.24, y: cY + -63.82), control1: .init(x: cX + -106.72, y: cY + -59.59), control2: .init(x: cX + -97.85, y: cY + -62.5))
        path.addCurve(to: .init(x: cX + -41.87, y: cY + -63.23), control1: .init(x: cX + -80.1, y: cY + -64.75), control2: .init(x: cX + -58.35, y: cY + -64.46))
        path.addLine(to: .init(x: cX + -41.87, y: cY + -63.23))
        
        
        path.closeSubpath()
        return path
    }
}

extension Color {
    init(hex2: String) {
        self.init(uiColor: .init(hex: hex2))
    }
    
    static func randomColor() -> Color {
        return Color(UIColor.random())
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1.0
        
        let len = hexSanitized.count
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        if len == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat((rgb & 0x0000FF)) / 255.0
        } else if len == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat((rgb & 0x000000FF)) / 255.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UInt32.max)
    }
}

extension UIImage {
    func getAverageColor(completion: @escaping (UIColor) -> Void) {
        guard let inputImage = CIImage(image: self) else {
            return
        }
        
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [
            kCIInputImageKey: inputImage,
            kCIInputExtentKey: extentVector
        ])
        else { return }
        
        guard let outputImage = filter.outputImage else { return }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: .init(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        completion(UIColor(red: CGFloat(bitmap[0])/255, green: CGFloat(bitmap[1])/255, blue: CGFloat(bitmap[2])/255, alpha: 1))
    }
}

#Preview {
    GitHubAnimationView()
}
