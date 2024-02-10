//
//  BookInfoView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct BookInfoView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(uiImage: .init(named: "bookCover")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text("Cybernetic Sirens")
                    .font(.headline)
                
                Text("Zenith Bionica")
                    .font(.subheadline)
                
                BookInfoButtonsView()
            }
            
            Spacer()
        }
        .padding(.vertical)
    }
}

#Preview {
    BookInfoView()
}
