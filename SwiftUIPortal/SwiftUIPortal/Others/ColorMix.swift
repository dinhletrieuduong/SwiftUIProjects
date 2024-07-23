//
//  ColorMix.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 25/6/24.
//
import SwiftUI

@available(iOS 18.0, *)
struct ColorMix: View {
    @State private var leftColor = Color.blue
    @State private var rightColor = Color.pink
    @State private var mix = 0.5

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                ColorPicker("Left", selection: $leftColor)
                    .labelsHidden()
                ColorPicker("Right", selection: $rightColor)
                    .labelsHidden()
            }

            HStack {
                VStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(leftColor)
                        .frame(width: 100, height: 100)
                    Text("\((1 - mix), format: .percent.precision(.fractionLength(0...2)))")
                }

                VStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(rightColor)
                        .frame(width: 100, height: 100)
                    Text("\(mix, format: .percent.precision(.fractionLength(0...2)))")
                }
            }

            // create a rectangle filled with our mixed color
            RoundedRectangle(cornerRadius: 16)
                .fill(leftColor.mix(with: rightColor, by: mix, in: .perceptual))
                .frame(width: 100, height: 100)

            Slider(value: $mix, in: 0...1)
        }
    }
}

private struct CircleLoading: View {
    let gradientColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]

    @State var degrees:Double = 0
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(lineWidth: 25)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.gray.opacity(0.3))
                Circle()
                    .stroke(lineWidth: 25)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(
                        AngularGradient
                            .init(gradient: Gradient(colors: gradientColors), center: .center)
                    )
                    .mask {
                        Circle()
                            .trim(from: 0, to: 0.15)
                            .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round)
                            )
                            .rotationEffect(.degrees(degrees))
                    }
            }
            .onAppear(){
                withAnimation(.linear(duration:2).repeatForever(autoreverses: false)) {
                    degrees += 360
                }
            }
            Spacer()

        }
        .padding(.top,20)

    }
}


#Preview {
    
    CircleLoading()
//    if #available(iOS 18.0, *) {
//        ColorMix()
//    } else {
//        // Fallback on earlier versions
//    }
}
