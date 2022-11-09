//
//  TransactionsView.swift
//  money-manage
//
//  Created by Dylan on 02/11/2022.
//

import Foundation
import SwiftUI

struct TransactionsView: View {
    
    var body: some View {
        VStack(spacing: -40) {
            HStack {
                Text("Send to money")
                    .font(.headline)
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundColor(Color(#colorLiteral(red: 0.3097526431, green: 0.3843510449, blue: 0.7528470159, alpha: 1)))
                    .frame(width: 30, height: 30)
                Text("Add recipient")
                    .font(.headline)
            }
            .padding(20)
            .padding(.bottom, 40)
            .foregroundColor(.white)
            .background(Color(#colorLiteral(red: 0.1019468382, green: 0.1058915928, blue: 0.1333118379, alpha: 1)))
            .cornerRadius(20)
            LazyVStack {
                ForEach(0..<10, id: \.self) { item in
                    TransactionRow()
                }
            }
            .background(Color.white)
            .cornerRadius(20)
        }
        .padding(.horizontal)
    }
}
