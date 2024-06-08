//
//  GlitchTextView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 9/6/24.
//

import SwiftUI

struct GlitchTextView: View {
    
    @State private var trigger: (Bool, Bool, Bool) = (false, false, false)
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                GlitchView("Hello Dylan!", trigger: trigger.0)
                    .font(.system(size: 60, weight: .semibold))
                
                GlitchView("Glitch Text Effect", trigger: trigger.1)
                    .font(.system(size: 40, design: .rounded))
                
                GlitchView("Some text here", trigger: trigger.2)
                    .font(.system(size: 20))
                
            }
            
            
            Button(action: {
                Task {
                    trigger.0.toggle()
                    
                    try? await Task.sleep(for: .seconds(0.5))
                    trigger.1.toggle()
                    
                    try? await Task.sleep(for: .seconds(0.5))
                    trigger.2.toggle()

                }
            }, label: {
                Text("Trigger Glitch")
                    .padding(.horizontal, 15)
            })
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.black)
        }
        .padding()
        
    }
    
    @ViewBuilder
    func GlitchView(_ text: String, trigger: Bool) -> some View {
        ZStack {
            GlitchText(text: text, trigger: trigger, frames: {
                LinearKeyframe(GlitchFrame(top: -5, center: 0, bottom: 0, shadowOpacity: 0.2), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: -5, center: -5, bottom: -5, shadowOpacity: 0.6), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: -5, center: -5, bottom: 5, shadowOpacity: 0.8), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: -5, center: 5, bottom: 5, shadowOpacity: 0.4), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.1), duration: 0.1)
                LinearKeyframe(GlitchFrame(), duration: 0.1)
            })
            
            GlitchText(text: text, trigger: trigger, shadow: .green, frames: {
                LinearKeyframe(GlitchFrame(top: 0, center: 5, bottom: 0, shadowOpacity: 0.2), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.3), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: 5, center: 5, bottom: -5, shadowOpacity: 0.5), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: 0, center: 5, bottom: -5, shadowOpacity: 0.6), duration: 0.1)
                LinearKeyframe(GlitchFrame(top: 0, center: -5, bottom: 0, shadowOpacity: 0.3), duration: 0.1)
                LinearKeyframe(GlitchFrame(), duration: 0.1)
            })
        }
    }
}


struct GlitchText: View {
    var text: String
    var trigger: Bool
    var shadow: Color
    var radius: CGFloat
    var frames: [LinearKeyframe<GlitchFrame>]
    
    init(text: String, trigger: Bool, shadow: Color = .red, radius: CGFloat = 1, @GlitchFrameBuilder frames: @escaping () -> [LinearKeyframe<GlitchFrame>]) {
        self.text = text
        self.trigger = trigger
        self.shadow = shadow
        self.radius = radius
        self.frames = frames()
    }
    
    var body: some View {
        KeyframeAnimator(initialValue: GlitchFrame(), trigger: trigger) { value in
            ZStack {
                TextView(.top, offset: value.top, opacity: value.shadowOpacity)
                TextView(.center, offset: value.center, opacity: value.shadowOpacity)
                TextView(.bottom, offset: value.bottom, opacity: value.shadowOpacity)
            }
            .compositingGroup() // Note requeired
        } keyframes: { _ in
            for frame in frames {
                frame
            }
        }

    }
    
    @ViewBuilder
    func TextView(_ alignment: Alignment, offset: CGFloat, opacity: CGFloat) -> some View {
        Text(text)
            .mask {
                if alignment == .top {
                    VStack(spacing: 0) {
                        Rectangle()
                        
                        ExtendedSpacer()
                        
                        ExtendedSpacer()
                    }
                }
                else if alignment == .center {
                    VStack(spacing: 0) {
                        ExtendedSpacer()
                        
                        Rectangle()
                        
                        ExtendedSpacer()
                    }
                    
                }
                else if alignment == .bottom {
                    VStack(spacing: 0) {
                        ExtendedSpacer()
                        
                        ExtendedSpacer()
                        
                        Rectangle()
                    }
                    
                    
                }
            }
            .shadow(color: shadow.opacity(opacity), radius: radius, x: offset, y: offset/2)
            .offset(x: offset)
        
    }
    
    @ViewBuilder
    func ExtendedSpacer() -> some View {
        Spacer(minLength: 0)
            .frame(maxHeight: .infinity)
        
    }
}

@resultBuilder
struct GlitchFrameBuilder {
    static func buildBlock(_ components: LinearKeyframe<GlitchFrame>...) -> [LinearKeyframe<GlitchFrame>] {
        return components
    }
}

struct GlitchFrame: Animatable {
    /// X - Offset's
    var top: CGFloat = 0
    var center: CGFloat = 0
    var bottom: CGFloat = 0
    var shadowOpacity: CGFloat = 0
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>> {
        get {
            return .init(top, .init(center, .init(bottom, shadowOpacity)))
        }
        set {
            top = newValue.first
            center = newValue.second.first
            bottom = newValue.second.second.first
            shadowOpacity = newValue.second.second.second
        }
    }
}

#Preview {
    GlitchTextView()
}
