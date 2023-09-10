//
//  CardList.swift
//  money-manage
//
//  Created by Dylan on 02/11/2022.
//

import SwiftUI

struct CardList: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(0..<4, id: \.self) { item in
                    MoneyManagerCardView(isSelected: item == 0)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
                }
            }
            .padding(20)
            
        }
    }
}
