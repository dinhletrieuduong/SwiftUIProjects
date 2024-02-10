//
//  DiscussinListRowView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct DiscussinListRowView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Club Lobby")
                    .font(.headline)
                
                Spacer()
                
                Label("42", systemImage: "message")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            
            DiscussinListNavigationLinkView()
        }
        .padding(.vertical)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    DiscussinListRowView()
}
