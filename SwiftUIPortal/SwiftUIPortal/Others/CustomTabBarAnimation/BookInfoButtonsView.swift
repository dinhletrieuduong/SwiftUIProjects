//
//  BookInfoButtonsView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct BookInfoButtonsView: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                
            }
            .font(.title2)
            
            HorizontalButtonView(label: "Sample", hasStroke: true) {
                
            }
            HorizontalButtonView(label: "View", hasStroke: false) {
                    
            }
            .foregroundStyle(.primary)
            .padding(.vertical)
        }
    }
}

#Preview {
    BookInfoButtonsView()
}
