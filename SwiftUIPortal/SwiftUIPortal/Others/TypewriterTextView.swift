//
//  TypewriterTextView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 03/02/2024.
//

import SwiftUI

struct TypewriterTextView: View {
    
    let text: String
    var delay: CGFloat = 25
    var font: Font
    var textAlignment: TextAlignment = .leading
    
    @State private var animatedText = ""
    
    var body: some View {
        VStack {
            Text(animatedText)
                .multilineTextAlignment(.center)
                .font(font)
                .padding()
                .task {
                    await animate()
                }
        }
    }
    
    private func animate() async {
        for char in text {
            animatedText.append(char)
            try? await Task.sleep(for: .milliseconds(delay))
        }
    }
}
    
#Preview {
    TypewriterTextView(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", font: .body)
}
