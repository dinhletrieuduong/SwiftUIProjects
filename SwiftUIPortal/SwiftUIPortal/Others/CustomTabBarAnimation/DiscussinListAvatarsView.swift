//
//  DiscussinListAvatarsView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct DiscussinListAvatarsView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.purple)
                .stroke(Color(.systemGray4), lineWidth: 2)
                .frame(width: 27)
            
            Circle()
                .fill(.purple)
                .stroke(Color(.systemGray4), lineWidth: 2)
                .frame(width: 27)
                .offset(x: 12)
            
            Circle()
                .fill(.purple)
                .stroke(Color(.systemGray4), lineWidth: 2)
                .frame(width: 27)
                .offset(x: 24)
            
        }
        .frame(maxHeight: .infinity)
        .padding(.trailing)
    }
}

#Preview {
    DiscussinListAvatarsView()
}
