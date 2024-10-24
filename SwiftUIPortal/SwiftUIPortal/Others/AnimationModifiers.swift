//
//  AnimationModifiers.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 11/10/24.
//

import SwiftUI

// https://www.youtube.com/watch?v=JsrVJvKv5fs&list=WL&index=78&t=133s

//    .phaseAnimator([0, 8, -8, 4, -4, 0], trigger: wrongPasswordTrigger) { content, offset in
//        content
//            .background {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill((isWrongPassword ? .red.opacity(0.1) : Color.primary.opacity(0.06)).gradient)
//            }
//            .offset(x: offset)
//    } animation: { _ in
//            .snappy(duration: 0.13, extraBounce: 0).speed(1.5)
//    }
//    .onChange(of: password) { oldValue, newValue in
//        isWrongPassword = false
//    }


///
//    .transition(.blurReplace(.downUp).combined(with: .push(from: .bottom)))

///
//    .contentTransition(.numericText)

///
struct Jump {
    var scaleY: CGFloat = 1
    var offsetY: CGFloat = 0
    var rotation: CGFloat = 0
}

private struct ContentVieww: View {
    @State private var triggerJump: Bool = false
    var body: some View {
        Button {

        } label: {
            Image(systemName: "suit.heart.fill")
                .foregroundStyle(.red.gradient)
        }
        .keyframeAnimator(initialValue: Jump(), trigger: triggerJump) { content, value in
            content
                .rotationEffect(.init(degrees: value.rotation), anchor: .bottom)
                .scaleEffect(y: value.scaleY, anchor: .bottom)
                .offset(y: value.offsetY)
        } keyframes: { _ in
            KeyframeTrack(\.scaleY) {
                /// Total duration: 1.0s
                SpringKeyframe(0.4, duration: 0.2, spring: .bouncy)
                CubicKeyframe(1.15, duration: 0.1)
                CubicKeyframe(1.15, duration: 0.5)
                CubicKeyframe(1, duration: 0.2)
            }
            KeyframeTrack(\.offsetY) {
                SpringKeyframe(15, duration: 0.2, spring: .smooth)
                SpringKeyframe(-12, duration: 0.6, spring: .smooth)
                SpringKeyframe(0, duration: 0.2, spring: .smooth)
            }
            KeyframeTrack(\.rotation) {
                CubicKeyframe(0, duration: 0.4)
                CubicKeyframe(14, duration: 0.1)
                CubicKeyframe(-14, duration: 0.1)
                CubicKeyframe(0, duration: 0.1)

            }
        }
        .task {
            try? await Task.sleep(for: .seconds(0.25))
            triggerJump = true
        }


    }
}

#Preview {
    ContentVieww()
}
