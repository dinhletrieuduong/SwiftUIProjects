//
//  RecButton.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 31/07/2021.
//

import SwiftUI

struct RecButton: View {
    @State private var isRec = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 100)
//                    .stroke(style: StrokeStyle(lineWidth: 1.0, lineCap: <#T##CGLineCap#>, lineJoin: <#T##CGLineJoin#>, miterLimit: <#T##CGFloat#>, dash: <#T##[CGFloat]#>, dashPhase: <#T##CGFloat#>))
                    .stroke(style: StrokeStyle(lineWidth: 1.0))
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius(using: 50))
                    .fill(Color.red)
                    .frame(width: recIconSize(using: 100), height: recIconSize(using: 100), alignment: .center)
                    .animation(.easeOut(duration: 0.125))
                    .onTapGesture {
                        isRec.toggle()
                    }
            }
        }
    }
    
    func cornerRadius(using size: CGFloat) -> CGFloat {
        if (isRec) {
            return size * 0.1
        }
        else {
            return size * 0.5
        }
    }
    func recIconSize(using size: CGFloat) -> CGFloat {
        return isRec ? size * 0.5 : size - (size * 0.18)
    }
}


