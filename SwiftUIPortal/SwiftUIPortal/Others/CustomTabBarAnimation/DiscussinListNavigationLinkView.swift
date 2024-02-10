//
//  DiscussinListNavigationLinkView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct DiscussinListNavigationLinkView: View {
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 12, bottomTrailingRadius: 12)
                .foregroundStyle(Color(.systemGray4))
            
            NavigationLink(destination: Text("Coming soon!")) {
                HStack(alignment: .top) {
                    Circle()
                        .frame(width: 12)
                        .foregroundStyle(.purple)
                        .offset(y: 5)
                    
                    VStack(alignment: .leading) {
                        Text("86 new posts")
                        
                        Text("Club Lobby")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                    }
                    
                    Spacer()
                    
                    DiscussinListAvatarsView()
                }
                .padding()
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    DiscussinListNavigationLinkView()
}
