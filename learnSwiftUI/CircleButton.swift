//
//  CircleButton.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 25/07/2021.
//

import Foundation

import SwiftUI

struct CircleButton : View {
    var imgLink : String
    var colorSet : String
    
    var body: some View {
        return Button(action: {
            
        }) {
            
            Image(imgLink)
                .renderingMode(.original)
                .padding()
            
        }.background(Color(colorSet))
        .clipShape(Circle())
    }
}
