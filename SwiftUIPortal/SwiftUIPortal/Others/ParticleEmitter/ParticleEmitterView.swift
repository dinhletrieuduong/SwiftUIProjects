//
//  ParticleEmitterView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 30/12/2023.
//

import SwiftUI

struct ParticleEmitterView: View {
    /// View properties
    @State private var isLiked: [Bool] = [false, false, false]


    var body: some View {
        VStack {
            HStack(spacing: 20, content: {
                CustomButton(systemImage: "suit.heart.fill", status: isLiked[0], activeTint: .pink, inactiveTint: .gray) {
                    isLiked[0].toggle()
                }
                
                CustomButton(systemImage: "star.fill", status: isLiked[1], activeTint: .yellow, inactiveTint: .gray) {
                    isLiked[1].toggle()
                }
                
                CustomButton(systemImage: "square.and.arrow.up.fill", status: isLiked[2], activeTint: .blue, inactiveTint: .gray) {
                    isLiked[2].toggle()
                }
            })
        }
    }
    
    /// Custom Button View
    @ViewBuilder
    func CustomButton(systemImage: String, status: Bool, activeTint: Color, inactiveTint: Color, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(systemImage: systemImage, font: .title2, status: status, activeTint: activeTint, inactiveTint: inactiveTint)
                .foregroundStyle(status ? activeTint : inactiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : .gray.opacity(0.25))
                }
        }
    }
}

#Preview {
    NavigationStack {
        ParticleEmitterView()
            .navigationTitle("Particle Emitter")
    }
    .preferredColorScheme(.dark)
}
