//
//  CalmariaVisualEffectView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 23/01/2024.
//

import SwiftUI

struct CalmariaVisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
