//
//  ShapeAnimation.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 17/11/2021.
//



import SwiftUI

struct ShapeAnimation: View {
    
    @State private var rotated = false
    @State private var enlarged = false
    @State private var slide = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 30) {
                    Button("Circle") { rotated.toggle() }
                    Button("Rectangle") { enlarged.toggle() }
                    Button("Capsule") { slide.toggle() }
                    Button("All") {
                        rotated.toggle()
                        enlarged.toggle()
                        slide.toggle()
                    }
                }
                ScrollView {
                    VStack {
                        CircleView(rotated: $rotated)
                        RectangleView(enlarged: $enlarged)
                        CapsuleView(slide: $slide)
                    }.frame(height: 700)
                }
            }
            .navigationTitle("Animating Shapes")
            .padding()
            
        }
        
    }
}

struct Animation2_Previews: PreviewProvider {
    static var previews: some View {
        ShapeAnimation()
    }
}


struct CircleView: View {
    @Binding var rotated: Bool
    
    var body: some View {
        Circle()
            .foregroundColor(Color.pink)
            .rotation3DEffect(
                .init(degrees: rotated ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0))
            .animation(Animation.easeInOut(duration: 0.5))
    }
}

struct RectangleView: View {
    @Binding var enlarged: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
            .foregroundColor(Color.purple)
            .scaleEffect(enlarged ? 1 : 0.5)
            .animation(Animation.spring())
    }
}


struct CapsuleView: View {
    @Binding var slide: Bool
    
    var body: some View {
        Capsule()
            .foregroundColor(Color.green)
            .offset(x: slide ? 0 : -400)
            .animation(.easeInOut(duration: 0.5))
    }
}
