    //
    //  SpreadingAnim.swift
    //  SpreadingAnim
    //
    //  Created by LAP14482 on 03/10/2021.
    //

import SwiftUI

struct PersonView: View {
    var rotated: Bool = false
    var body: some View {
        Image(systemName: "figure.walk")
            .resizable()
            .frame(width: 40, height: 40, alignment: .center)
            .rotation3DEffect(
                .degrees(rotated ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
}
struct SpreadingAnim: View {
    @State private var socialDistance = false
    private var scale : CGFloat {
        self.socialDistance ? 0.6 : 0.1
    }
    private let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        VStack {
            Text("6 ft")
                .offset(y:30)
                .opacity(socialDistance ? 1 : 0)
            HStack {
                PersonView()
                Rectangle()
                    .frame(width: screenWidth * scale, height: 5)
                    .foregroundColor(scale < 0.6 ? .red : .green)
                PersonView(rotated: true)
            }
            Button(action: {
                socialDistance.toggle()
            }, label: {
                Text(!socialDistance ? "Start Spreading" : "Stop Spreading")
                    .padding(EdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0))
                    .font(.headline)
            })
        }
        .animation(.easeIn(duration: 0.7))
    }
}

struct SpreadingAnim_Previews: PreviewProvider {
    static var previews: some View {
        SpreadingAnim()
    }
}
