//
//  MoodView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 1/11/24.
//

import SwiftUI
// https://www.youtube.com/watch?v=Nz23q4WzEKk&list=WL&index=53
struct Emoji {
    let emoji: String
    let color: Color
}

struct MoodView: View {

    @State private var emojies: [Emoji] = [
        .init(emoji: "🥰", color: .pink),
        .init(emoji: "😊", color: .orange),
        .init(emoji: "😍", color: .blue),
        .init(emoji: "😇", color: .purple),
        .init(emoji: "😌", color: .green),
    ]

    @State private var selectedEmoji: Emoji? = nil
    @State private var animate: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack {

            }
        }
    }
}
