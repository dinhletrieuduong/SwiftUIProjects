//
//  PlayStationLoaderView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 28/10/24.
//

import SwiftUI

struct DemoPlayStationLoaderView: View {
    @State private var animateDiamond: Bool = false
    @State private var animatePlus: Bool = false
    @State private var animateCircle: Bool = false
    @State private var animateTriangle: Bool = false

    private let backgroundShapeSize = 110.0
    private let movementOffset = -50.0

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                createAnimatedShape(image: "diamond", animatedState: $animateDiamond)
                    .onAppear {
                        animateDiamond = true
                    }
                createAnimatedShape(image: "plus", animatedState: $animatePlus)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                            self.animatePlus = true
                        }
                    }
            }
            HStack(spacing: 0) {
                createAnimatedShape(image: "circle", animatedState: $animateCircle)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.animateCircle = true
                        }
                    }
                createAnimatedShape(image: "triangle", animatedState: $animateTriangle)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            self.animateTriangle = true
                        }
                    }
            }

        }
        .rotationEffect(.degrees(-1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.pink)
        .ignoresSafeArea()
    }

    func createAnimatedShape(image: String, animatedState: Binding<Bool>) -> some View {
        BackgroundShapeView(xOffset: animatedState.wrappedValue ? movementOffset : 0, yOffset: animatedState.wrappedValue ? movementOffset : 0)
            .fill(.blue)
            .frame(width: backgroundShapeSize, height: backgroundShapeSize)
            .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: true), value: animatedState.wrappedValue)
            .overlay {
                ForegroundShapeView(image: image, fill: .pink)
                    .offset(x: animatedState.wrappedValue ? movementOffset : 0, y: animatedState.wrappedValue ? movementOffset : 0)
                    .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: true), value: animatedState.wrappedValue)

            }
    }
}


struct ForegroundShapeView: View {
    private let foregroundShapeSize = 100.0
    private let iconSize = 60.0

    let image: String
    let fill: Color

    var body: some View {
        Rectangle()
            .fill(fill)
            .frame(width: foregroundShapeSize, height: foregroundShapeSize)
            .overlay {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize)
                    .foregroundStyle(.blue)
            }
    }
}

struct BackgroundShapeView: Shape {
    var xOffset: CGFloat = 0.0
    var yOffset: CGFloat = 0.0

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(xOffset, yOffset)
        }
        set {
            xOffset = newValue.first
            yOffset = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: .init(x: rect.minX + xOffset, y: rect.minY + yOffset))
        path.addLine(to: .init(x: rect.width + xOffset, y: rect.minY + yOffset))
        path.addLine(to: .init(x: rect.width, y: rect.minY))
        path.addLine(to: .init(x: rect.width, y: rect.maxY))
        path.addLine(to: .init(x: rect.width + xOffset, y: rect.height + yOffset))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX + xOffset, y: rect.height + yOffset))
        path.closeSubpath()

        return path
    }
}

#Preview {
    DemoPlayStationLoaderView()
}
