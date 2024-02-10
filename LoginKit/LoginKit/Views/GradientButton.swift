//
//  GradientButton.swift
//  LoginKit
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var icon: String
    var onClick: (() -> Void)
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 15) {
                Text(title)
                
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(
                .linearGradient(colors: [.appYellow, .orange, .red], startPoint: .top, endPoint: .bottom),
                in: .capsule
            )
        }
    }
}
