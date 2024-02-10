//
//  HorizontalButtonView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct HorizontalButtonView: View {
    let label: String
    let hasStroke: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .fontWeight(.semibold)
                .foregroundStyle(hasStroke ? .primary : Color(.secondarySystemBackground))
                .padding(.vertical, 4)
                .padding(.horizontal)
        }
        .background(
            ZStack {
                Capsule()
                    .foregroundStyle(hasStroke ? .clear : .primary)
                if hasStroke {
                    Capsule()
                        .stroke(.primary, lineWidth: 2)
                }
            }
        )
    }
}
