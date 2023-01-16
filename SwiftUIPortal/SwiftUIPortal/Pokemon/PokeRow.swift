//
//  PokeRow.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

struct PokeRow: View {
    var sprite: Image
    var info: Pokemon
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text("#\(info.id)")
                AsyncImage(url: URL(string: info.sprites.frontDefault ?? ""))
            }
            VStack(alignment: .leading) {
                Text("\(info.name.capitalized)")
                    .font(.headline)
                LazyHStack {
                    ForEach(0..<info.types.count, id: \.self) { index in
                        TypeChip(name: info.types[index].type.name, color: Colors[info.types[index].type.name.lowercased().capitalized] ?? .red)
                        
                    }
                    Spacer()
                }
                .fixedSize()
//                TypeChipList(types: info.types)
                
            Spacer()
            }
            Spacer()
        }
    }
}
