//
//  TypeChipList.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

struct TypeChip: View {
    var name: String
    var color: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(color)
            HStack {
                Text(name.localizedCapitalized)
                    .font(.footnote)
                    .padding(4)
                    .background(
                        .thickMaterial,
                        in: RoundedRectangle(cornerRadius: 8.0)
                    )
            }
            .padding(4)
        }
    }
}
