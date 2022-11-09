//
//  OpacityAnimation.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 17/11/2021.
//

import Foundation

import SwiftUI

struct OpacityAnimation: View {
    
    @State private var hidden = false
    
    var body: some View {
        Label("Play", systemImage: "play")
            .padding()
            .background(Color.orange)
            .opacity(hidden ? 0 : 1)
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/(duration: 1))
            .onTapGesture {
                playMusic()
            }
    }
    
    private func playMusic() {
        hidden = true
    }
}

struct Opacity_Previews: PreviewProvider {
    static var previews: some View {
        OpacityAnimation()
    }
}
