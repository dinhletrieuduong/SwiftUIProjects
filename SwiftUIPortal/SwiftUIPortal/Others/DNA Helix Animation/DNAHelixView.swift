//
//  DNAHelixView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 3/10/24.
//

import SwiftUI

struct DNAHelixView: View {
    var amplitude: Double = 30
    var frequency: Double = 15
    var spacing: Double = 10
    var pointRadius: Double = 3
    var lineWidth: Double = 1.5
    var phaseChangePerSecond: Double = 2

    var rotationAngle: Angle = .degrees(0)

    var firstColor: Color = .red
    var secondColor: Color = .blue
    var lineGradientColors: [Color] = [.red, .yellow, .blue]

    var body: some View {
        TimelineView(.animation) { timeline in
            let phase = getPhase(date: timeline.date)
            Canvas { context, size in

                let containerWidth = Double(size.width)
                let originalX = containerWidth/2
                let containerHeight = Double(size.height)
                let originalY = containerHeight/2

                let midHeight = containerHeight / 2
                let wavelength = containerWidth / frequency

                let newX = originalX * cos(rotationAngle.radians) - originalY * sin(rotationAngle.radians)
                let newY = originalX * sin(rotationAngle.radians) + originalY * cos(rotationAngle.radians)


                context.translateBy(x: (originalX - newX), y: (originalY-newY))
                context.rotate(by: rotationAngle)

                print(rotationAngle.radians)

                let newWidth = (rotationAngle == .degrees(90) || rotationAngle == .degrees(270)) ? containerHeight : abs(containerWidth / cos(rotationAngle.radians))

                let widthDifference = newWidth - containerWidth

                for x in stride(from: -widthDifference/2-wavelength, through: containerWidth + widthDifference/2+wavelength, by: spacing) {
                    let relativeX = x / wavelength
                    let sine = sin(relativeX + phase)
                    let y = amplitude * sine + midHeight
                    let minusY = -amplitude * sine + midHeight
                    drawCircle(context: context, center: CGPoint(x: x, y: y), color: firstColor)

                    drawLine(context: context, start: CGPoint(x: x, y: y), end: CGPoint(x: x, y: minusY))

                    drawCircle(context: context, center: CGPoint(x: x, y: minusY), color: secondColor)

                }
            }

        }
    }

    func getPhase(date: Date) -> Double {
        return date.timeIntervalSince1970 * phaseChangePerSecond
    }

    func drawCircle(context: GraphicsContext, center: CGPoint, color: Color) {
        let path = Path { path in
            path.move(to: center)
            path.addArc(center: center, radius: pointRadius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        }
        context.stroke(path, with: .color(color), lineWidth: lineWidth)

    }

    func drawLine(context: GraphicsContext, start: CGPoint, end: CGPoint) {
        let path = Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }

        context.stroke(path, with: .linearGradient(.init(colors: lineGradientColors), startPoint: start, endPoint: end), lineWidth: lineWidth)
    }
}

#Preview {
    ZStack {
        DNAHelixView(rotationAngle: .degrees(30), firstColor: .green, secondColor: .yellow, lineGradientColors: [.green, .orange, .yellow])
            .offset(y: -150)
        DNAHelixView(rotationAngle: .degrees(120))
    }
}
