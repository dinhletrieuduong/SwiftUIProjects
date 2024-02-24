//
//  AnimatedExampleView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 23/02/2024.
//

import SwiftUI

struct AnimatedExampleView: View {
    @State var isExpanded: Bool = true
    
    // Identifier for the rectangle view
    private var rectangleId = "Rectangle"
    
    // Namespace for the expansion effect
    @Namespace var expansionAnimation
    
    var body: some View {
        VStack {
            if isExpanded {
                smallSizeView()
            } else {
                largeSizeView()
            }
        }
        .padding()
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
    
    @ViewBuilder
    func smallSizeView() -> some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.black)
            .frame(width: 300,height: 300, alignment: .center)
        // Added the matched geometry modifier to the view
            .matchedGeometryEffect(id: rectangleId, in: expansionAnimation, properties: .position)
            
            .overlay {
                Text("Hello Developer")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
    }
    
    @ViewBuilder
    func largeSizeView() -> some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.black)
        // Added the matched geometry modifier to the view
            .matchedGeometryEffect(id: rectangleId, in: expansionAnimation, properties: .x)
            .overlay {
                Text("Hello Developer")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
    }
    
}

#Preview {
    AnimatedExampleView()
}
