//
//  CardView.swift
//  money-manage
//
//  Created by Dylan on 02/11/2022.
//

import SwiftUI

struct CardView: View {
    
    @State var isSelected: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image("visaIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 15)
                    .foregroundColor(isSelected ? .white : .black)
                    .padding()
            }
            Spacer()
            Text("Balance")
                .font(.caption)
                .foregroundColor(isSelected ? .white : .black)
                .padding(.bottom)
            HStack(alignment: .center) {
                Text("USD")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .black)
                Text("$17,234.50")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(isSelected ? .white : .black)
            }
            .padding(.bottom)
            Spacer()
            Text("**** **** **** 9401")
                .font(.caption)
                .foregroundColor(isSelected ? .white : .black)
                .padding(.bottom)
            Spacer()
        }
        .frame(width: 130, height: 150)
        .padding(8)
        .background(Color(isSelected ? #colorLiteral(red: 0.3097526431, green: 0.3843510449, blue: 0.7528470159, alpha: 1) : .white))
        .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(isSelected: true)
                .previewLayout(.sizeThatFits)
            CardView(isSelected: false)
                .previewLayout(.sizeThatFits)
        }
    }
}
