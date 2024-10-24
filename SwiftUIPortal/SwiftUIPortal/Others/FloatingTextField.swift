//
//  FloatingTextField.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/10/24.
//


import SwiftUI

struct FloatingTextField: View {
    let placeholderText: String
    @State private var text: String = ""

    let animation: Animation = .spring(response: 0.1, dampingFraction: 0.6)

    @State private var placeholderOffset: CGFloat
    @State private var scaleEffectValue: CGFloat

    private var onTextAction: ((_ oldValue : String ,_ newValue : String) -> ())?

    init(placeholderText: String, placeholderOffset: CGFloat = 0, scaleEffectValue: CGFloat = 1, onTextAction: ((_: String, _: String) -> Void)? = nil) {
        self.placeholderText = placeholderText
        self.placeholderOffset = placeholderOffset
        self.scaleEffectValue = scaleEffectValue
        self.onTextAction = onTextAction
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholderText)
                .foregroundStyle($text.wrappedValue.isEmpty ? Color.white : .gray)
                .font($text.wrappedValue.isEmpty ? .headline : .caption)
                .offset(y: placeholderOffset)
                .scaleEffect(scaleEffectValue, anchor: .leading)

            TextField("", text: $text)
                .font(.headline)
                .foregroundStyle(Color.yellow)
        }
        .padding()
        .padding(.vertical, 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 2)
        )
        .onChange(of: text) { oldValue, newValue in
            withAnimation(animation) {
                placeholderOffset = $text.wrappedValue.isEmpty ? 0 : -25
                scaleEffectValue = $text.wrappedValue.isEmpty ? 1 : 0.75
            }

            onTextAction?(oldValue, newValue)
        }
    }
}

extension FloatingTextField {
    public func onTextChange(_ onTextAction: ((_ oldValue : String ,_ newValue : String) -> ())?) -> Self {
        var view = self
        view.onTextAction = onTextAction
        return view
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        ZStack {
            FloatingTextField(placeholderText: "Name")
        }
        .padding()
    }
}
