//
//  BounceTextAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 8/11/24.
//

import SwiftUI

struct BounceTextAnimation: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack {
                Text("SwiftUI Codes\n\(Text("Text Animation").foregroundStyle(.pink))")
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
                    .padding()
                    .foregroundStyle(.green)

                FirstTextAnimationView(
                    text: "Text Animation",
                    startTime: 0,
                    textFont: .system(size: 30),
                    textColor: .white
                )

                FirstTextAnimationView(
                    text: "Made by @Dylan",
                    startTime: 1.5, // Add delay before this text starts animating
                    textFont: .title,
                    textColor: .orange
                )
                .padding(.top, 10)
            }
        }

    }
}


struct FirstTextAnimationView: View {
    let characters: Array<String.Element>
    @State var offsetYForBounce: CGFloat = -50 // Y-axis offset for bounce animation (starts off-screen)
    @State var opacity: CGFloat = 0
    @State var baseTime: Double // Base time delay for animation start
    @State var textColor: Color
    @State var textFont: Font

    init(text: String, startTime: Double, textFont: Font, textColor: Color = .white) {
        self.characters = Array(text)
        self.baseTime = startTime
        self.textFont = textFont
        self.textColor = textColor
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<characters.count, id: \.self) { num in
                Text(String(characters[num]))
                    .font(textFont)
                    .offset(x: 0, y: offsetYForBounce)
                    .opacity(opacity)
                    .animation(
                        .spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.1)
                        .delay(Double(num) * 0.1),
                        value: offsetYForBounce
                    )
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            .onTapGesture {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    opacity = 0 // Fade out all characters
                    offsetYForBounce = -50 // Move characters out of screen
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    opacity = 1 // Fade characters back in
                    offsetYForBounce = 0 // Bring characters back to original position
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0 + baseTime) {
                    opacity = 1 // Make all characters visible
                    offsetYForBounce = 0 // Bounce characters into place
                }
            }
        }
    }
}

#Preview {
    BounceTextAnimation()
}


