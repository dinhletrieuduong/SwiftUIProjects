//
//  LinkedInLoader.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 16/11/2021.
//

import Foundation
import SwiftUI

fileprivate struct Line: Shape {
    var leftHorizontalPosition: CGFloat
    var rightHorizontalPosition: CGFloat
    var verticalPosition: CGFloat = UIScreen.main.bounds.height / 2
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: leftHorizontalPosition, y: verticalPosition))
            path.addLine(to: CGPoint(x: rightHorizontalPosition, y: verticalPosition))
        }
    }
}

struct LinkedInLoader: View {
    @State private var loading = false
    
    var body: some View {
        ZStack {
            // gray line
            Line(leftHorizontalPosition: baseLineStartPosition, rightHorizontalPosition: baseLineEndPosition)
                .stroke(Color(UIColor.gray.cgColor), lineWidth: lineWidth)
            
            // blue anim line
            Line(leftHorizontalPosition: baseLineStartPosition + 20, rightHorizontalPosition: baseLineEndPosition - 20)
                .stroke(Color(UIColor.blue.cgColor), lineWidth: lineWidth)
                .offset(x: loading ? -70 : 70)
                .animation(Animation.easeOut(duration: 0.8).repeatForever(autoreverses: true))
            
            // white line which is same color as the background, so invisble
            Line(leftHorizontalPosition: 0, rightHorizontalPosition: baseLineStartPosition)
                .stroke(Color.white, lineWidth: lineWidth)
            // white line which is same color as the background, so invisble
            Line(leftHorizontalPosition: baseLineEndPosition, rightHorizontalPosition: screenWidth)
                .stroke(Color.white, lineWidth: lineWidth)
            
            // Logo
//            Image("linkedInLogo")
//                .resizable()
//                .frame(width: 70, height: 100)
//                .offset(y: -40)
        }
        .onAppear {
            loading = true
        }
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    private let lineWidth: CGFloat = 3.0
    private var baseLineStartPosition: CGFloat {
        screenWidth / 2 - screenWidth * 0.2
    }
    private var baseLineEndPosition: CGFloat {
        screenWidth / 2 + screenWidth * 0.2
    }
}

struct LinearLoaderView: View {
    let height: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color

    @State private var animating = false

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let lineWidth = width/2

            Capsule()
                .fill(backgroundColor)
                .frame(width: lineWidth)
                .overlay {
                    Capsule()
                        .fill(foregroundColor)
                        .frame(width: lineWidth)
                        .offset(x: animating ? -lineWidth : lineWidth)
                        .animation(.easeInOut(duration: 0.85).repeatForever(), value: animating)
                }
        }
        .frame(height: height)
        .clipShape(Capsule())
        .onAppear(perform: {
            animating.toggle()
        })
    }
}

#Preview {
//    LinearLoaderView(height: 5, backgroundColor: .gray, foregroundColor: .blue)

    LinkedInLoader()
}
