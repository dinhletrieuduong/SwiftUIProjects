//
//  ListItem.swift
//  TranslucentBackground
//
//

import SwiftUI

struct ListItem: View {
    var image: String = ""
    var name: String = ""
    var timestamp: String = ""
    var amount: String = ""
    
    var body: some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .frame(width: 42, height: 42)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.custom("Inter-Bold", size: 17))
//                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(timestamp)
                    .font(.custom("Inter-Regular", size: 15))
//                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Text(amount)
//                .font(.system(size: 20, weight: .bold, design: .rounded))
                .font(.custom("Inter-Bold", size: 17))
                .foregroundColor(.primary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem()
    }
}
