//
//  LongPressButton.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 23/7/24.
//

import SwiftUI

struct LongPressButtonView: View {

    @State private var hPress: Bool = false
    @State private var fb: Bool = false
    @GestureState var topG = false

    var body: some View {
        ZStack {
            Color.gray.opacity(0.4)

            ZStack {
                Circle()
                    .frame(width: 130, height: 130)
                    .foregroundStyle(.white.opacity(0.2))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 10, y: 10)
                    .shadow(color: .white.opacity(0.6), radius: 10, x: -20, y: -20)

                Circle()
                    .stroke(lineWidth: 7)
                    .frame(width: 130, height: 130)
                    .foregroundStyle(.white.opacity(0.1))

                Circle()
                    .stroke(lineWidth: 5.5)
                    .frame(width: 115, height: 105)
                    .foregroundStyle(LinearGradient(gradient: .init(colors: [.black.opacity(0.06), .black.opacity(0.01), .black.opacity(0.06)]), startPoint: .topLeading, endPoint: .bottomTrailing))

                if topG {
                    Circle()
                        .stroke(lineWidth: 15)
                        .frame(width: 105, height: 105)
                        .foregroundStyle(LinearGradient(gradient: .init(colors: [.black.opacity(0.01), .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .blur(radius: 3)
                }

                ZStack {
                    Circle()
                        .frame(width: 90, height: 90)
                        .foregroundStyle(.white)

//                    Image("print")
                    Image(systemName: "touchid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(50)
                        .scaleEffect(hPress ? 0 : 1)
                        .padding(10)

                    Image(systemName: "touchid")
//                    Image("print")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.green)
                        .frame(width: 80, height: 80)
                        .cornerRadius(50)
                        .scaleEffect(hPress ? 0 : 1)
                        .clipShape(Circle().offset(y: topG ? 0 : 120))
                        .animation(.easeInOut.speed(0.3), value: topG)

                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 60))
                        .scaleEffect(hPress ? 1 : 0)
                        .animation(.easeInOut, value: hPress)
                }
                .overlay(content: {
                    Circle()
                        .trim(from: 0, to: topG ? 1 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                })
                .animation(.easeInOut.speed(0.3), value: topG)
                .foregroundStyle(.gray)
            }
            .scaleEffect(topG ? 1.2 : 1)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 1.5, maximumDistance: 1)
                    .updating($topG, body: { cState, gState, transition in
                        print("AAAA")
                        gState = cState
                        transition.animation = Animation.easeIn(duration: 2.0)
                    })
                    .onEnded({ value in
                        print("BBBBB \(hPress)")
                        print("DDDD \(topG)")
                        withAnimation {
                            hPress.toggle()
                        }
                    })
            )
            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: topG)
        }
    }
}

#Preview {
    LongPressButtonView()
}
