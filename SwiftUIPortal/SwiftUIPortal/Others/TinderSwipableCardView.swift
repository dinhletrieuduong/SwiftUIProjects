//
//  TinderSwipableCardView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

struct TinderSwipableCardView: View {
    
    // 1. Create a State for manipulating the offset of the card
    @State private var offset: CGSize = .zero
    let customGradient1 = [Color.blue, Color.yellow, Color.blue]
    let customGradient2 = [Color.orange, Color.yellow, Color.orange]
    
    var body: some View {
        // 2. Create the Drag gesture
        let drag = DragGesture()
        // 3. Change the Card's offset while dragging
            .onChanged { value in
                self.offset = value.translation
            }
            .onEnded { value in
                if value.translation.width < -100 {
                    self.offset = .init(width: -1000, height: 0)
                    print("Swipe left")
                }
                else if value.translation.width > 100 {
                    self.offset = .init(width: 1000, height: 0)
                    print("Swipe Right")
                }
                else {
                    self.offset = .zero
                }
            }
        
        // 4. Return the view body's content
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                    // Check out the last post to see how to use gradient
                        .fill(LinearGradient(gradient: .init(colors: customGradient1), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 300, height: 500, alignment: .center)
                        .cornerRadius(30)
                        .offset(x: -5, y: -5)
                    Rectangle()
                        .fill(LinearGradient(gradient: .init(colors: customGradient2), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 300, height: 500, alignment: .center)
                        .cornerRadius(30)
                    // 7. Make the card's offset be dependent on the State
                        .offset(x: offset.width, y: offset.height)
                    // 8. Add the drag gesture to the card
                        .gesture(drag)
                    // Determine an animation styllee
                        .animation(.spring(), value: offset)
                }
            }
            
            .navigationTitle("Swipable Card")
        }
    }
}
