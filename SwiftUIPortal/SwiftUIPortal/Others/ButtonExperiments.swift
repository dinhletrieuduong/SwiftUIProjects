//
//  ButtonExperiments.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 18/02/2024.
//

import SwiftUI
import CameraView
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var x = 0.0
    
    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            
            guard let motion = data?.attitude else { return }
            self?.x = motion.roll
        }
    }
}

struct ButtonExperiments: View {
    @State private var tap1 = false
    @State private var gradientAngle: Double = 0
    @StateObject private var motion = MotionManager()
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 120) {
                ZStack {
                    
                    //MARK: Camera
                    
                    CameraView(cameraPosition: .front)
                        .scaleEffect(6)
                        .blur(radius: 6, opaque: true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 80)
                                .stroke(style: .init(lineWidth: 1))
                                .frame(width: 301, height: 101)
                            
                            //MARK: Inner Shadows
                            
                                .shadow(color: tap1 ? .black.opacity(1) : .white, radius: tap1 ? 8 : 6, x: 0, y: 6)
                                .shadow(color: tap1 ? .black.opacity(1) : .white, radius: tap1 ? 8 : 4, x: 0, y: -1)
                                .foregroundColor(.black)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 80)
                                .foregroundStyle(
                                    Color("fill").opacity(0.4)
                                    
                                    //MARK: Extra Inner Shadows
                                    
                                        .shadow(.inner(color: tap1 ? .black.opacity(0.6) : .white.opacity(0.6), radius: tap1 ? 8 : 10, x: 0, y: 6))
                                        .shadow(.inner(color: tap1 ? .black.opacity(0.6) : .white.opacity(0.6), radius: tap1 ? 8 : 5, x: 0, y: -1))
                                )
                                .frame(width: 300, height: 100)
                        )
                        .saturation(0.6)
                    
                    //MARK: Gradient
                    
                        .overlay(
                            Circle()
                                .fill(
                                    AngularGradient(gradient: Gradient(colors: [Color("color1"), Color("color2"), Color("color3"), Color("color4"), Color("color5"), Color("color6"), Color("color7"), Color("color8"), Color("color1")]), center: .center)
                                    
                                )
                                .scaleEffect(5)
                                .offset(y: -70)
                                .rotationEffect(.degrees(25) * motion.x)
                        )
                        .blendMode(.softLight)
                        .saturation(0.45)
                        .frame(width: 300, height: 100)
                        .mask(RoundedRectangle(cornerRadius: 80)
                            .fill((Color("background"))
                                 ))
                    
                    //MARK: Text
                    
                    Text("Button")
                        .font(.system(.title, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color("text1"), Color("text2")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(0.8)
                        .shadow(color: .white.opacity(0.1), radius: 1, x: 0, y: 0)
                        .shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: 1)
                    
                }
                
                //MARK: Drop Shadows
                
                .shadow(color: tap1 ? .white.opacity(0.2) : .black.opacity(0.25), radius: tap1 ? 9 : 8, x: 0, y: tap1 ? 3 : 12)
                .shadow(color: tap1 ? .white.opacity(0.2) : .black.opacity(0.15), radius: tap1 ? 10 : 32, x: 0, y: tap1 ? -4 : 6)
                
                .onTapGesture {
                    tap1 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        tap1 = false
                    }
                }
                .scaleEffect(tap1 ? 0.96 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6))
                
            }
        }
    }
}


#Preview {
    ButtonExperiments()
}

struct ButtonTwo: View {
    @State private var tap2 = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 80)
                .fill((Color("background"))
                    .shadow(.inner(color: tap2 ? .black.opacity(0.1) : .white.opacity(0.25), radius: tap2 ? 8 : 4, x: 0, y: 6))
                    .shadow(.inner(color: tap2 ? .black.opacity(0.1) : .white.opacity(0.3), radius: tap2 ? 8 : 2, x: 0, y: tap2 ? -2 : -1))
                )
                .frame(width: 300, height: 100)
                .shadow(color: tap2 ? .white.opacity(0.25) : .black.opacity(0.2), radius: tap2 ? 9 : 8, x: 0, y: tap2 ? 3 : 12)
                .shadow(color: tap2 ? .white.opacity(0.25) : .black.opacity(0.1), radius: tap2 ? 10 : 32, x: 0, y: tap2 ? -4 : 6)
            
            Text("Button 2")
                .font(.system(.title, weight: .semibold))
                .foregroundColor(Color("text"))
        }
        .onTapGesture {
            tap2 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tap2 = false
            }
        }
        .scaleEffect(tap2 ? 0.95 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.6))
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 120)
            .padding(.vertical, 38)
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 80)
                            .fill((Color("background"))
                                .shadow(.inner(color: .black.opacity(0.20), radius: 8, x: 0, y: 3))
                                .shadow(.inner(color: .black.opacity(0.1), radius: 8, x: 0, y: -2))
                            )
                            .shadow(color: .white.opacity(0.25), radius: 9, x: 0, y: 3)
                            .shadow(color: .white.opacity(0.25), radius: 10, x: 0, y: -4)
                            .scaleEffect(
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    0.95
                                }
                            )
                        
                    } else {
                        RoundedRectangle(cornerRadius: 80)
                            .fill((Color("background"))
                                .shadow(.inner(color: .white.opacity(0.25), radius: 4, x: 0, y: 8))
                                .shadow(.inner(color: .white.opacity(0.3), radius: 2, x: 0, y: -2))
                            )
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 12)
                            .shadow(color: .black.opacity(0.1), radius: 32, x: 0, y: 6)
                            .scaleEffect(
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    1
                                }
                            )
                    }
                }
            )
    }
}
