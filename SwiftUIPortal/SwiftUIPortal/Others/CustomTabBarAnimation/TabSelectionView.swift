//
//  TabSelectionView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct TabSelectionView: View {
    @Binding var tabSelection: Int
    
    @Namespace private var buttonID
    
    private let selectionButtons: [String] = ["Discussin", "Schedule", "Resources"]
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(selectionButtons.indices, id: \.self) { index in
                VStack {
                    Button(selectionButtons[index]) {
                        withAnimation {
                            tabSelection = index
                        }
                    }
                    .foregroundStyle(tabSelection == index ? .primary : .secondary)
                    .padding(.horizontal)
                    
                    if tabSelection == index {
                        Capsule()
                            .frame(width: 80, height: 4)
                            .padding(.horizontal, 4)
                            .foregroundStyle(.purple)
                            .matchedGeometryEffect(id: "ID", in: buttonID)
                    } else {
                        EmptyView()
                            .frame(height: 4)
                            .matchedGeometryEffect(id: "ID", in: buttonID)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    TabSelectionView(tabSelection: .constant(1))
}
