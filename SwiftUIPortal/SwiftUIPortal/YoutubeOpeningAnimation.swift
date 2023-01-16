//
//  YoutubeOpeningAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

struct YoutubeOpeningAnimation: View {
    @State var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "play.rectangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(width: 70, height: 70, alignment: .center)
                
                if isAnimating {
                    Text("Youtube")
                        .font(.largeTitle)
                        .opacity(isAnimating ? 1 : 0)
                        .transition(.opacity.animation(.easeInOut(duration: 0.2).delay(0.5)))
                }
            }
            
            Button("Animate") {
                withAnimation {
                    isAnimating.toggle()
                }
            }
            
            Spacer()
        }
    }
}

struct YoutubeOpeningAnimation_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeOpeningAnimation()
    }
}
