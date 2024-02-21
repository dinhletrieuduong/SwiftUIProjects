//
//  FluidMusicButton.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 21/02/2024.
//

import SwiftUI

struct FluidMusicButton: View {
    @State private var isPlaying = false
    @State private var opacity: CGFloat = 0.0
    
    var body: some View {
        Button {
            isPlaying.toggle()
            opacity = 0.6
            
            withAnimation(.easeOut(duration: 0.2)) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    opacity = 0
                }
            }
            
        } label: {
            ZStack {
                Circle()
                    .frame(width: 90, height: 90)
                    .opacity(opacity)
                
                Image(systemName: "pause.fill")
                    .font(.system(size: 64))
                    .scaleEffect(isPlaying ? 1 : 0)
                    .opacity(isPlaying ? 1 : 0)
                    .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: isPlaying)
                
                Image(systemName: "play.fill")
                    .font(.system(size: 64))
                    .scaleEffect(!isPlaying ? 1 : 0)
                    .opacity(!isPlaying ? 1 : 0)
                    .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: isPlaying)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FluidMusicButton()
}
