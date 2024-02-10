//
//  DiscussinListView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct DiscussinListView: View {
    var body: some View {
        List {
            ForEach(0..<5) { _ in
                DiscussinListRowView()
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    DiscussinListView()
}
