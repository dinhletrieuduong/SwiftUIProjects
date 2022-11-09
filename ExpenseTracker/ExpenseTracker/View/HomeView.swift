//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Dylan on 02/11/2022.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject var expenseViewModel: ExpenseViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome!")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("Dylan")
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    NavigationLink {
                        FilterDetailView().environmentObject(expenseViewModel)
                    } label: {
                        Image(systemName: "hexagon.fill")
                            .foregroundColor(.gray)
                            .overlay(content: {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .padding(7)
                            })
                            .frame(width: 40, height: 40)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                        
                    }
                }
                
                ExpenseCardView()
                    .environmentObject(expenseViewModel)
                
                TransactionsView()
                
            }
            .padding()
        }
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $expenseViewModel.addNewExpense) {
            
        } content: {
            NewExpenseView()
                .environmentObject(expenseViewModel)
        }
        .overlay(alignment: .bottomTrailing) {
            AddTransactionButton()
        }

    }
    
    // MARK: Add new expense transaction
    @ViewBuilder
    func AddTransactionButton() -> some View {
        Button {
            expenseViewModel.addNewExpense.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background {
                    Circle()
                        .fill(
                            .linearGradient(colors: [Color("Gradient1"),Color("Gradient2"),Color("Gradient3")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                }
        }
    }
    
    // MARK: Transactions View
    @ViewBuilder
    func TransactionsView() -> some View {
        VStack(spacing: 15) {
            Text("Transactions")
                .font(.title2.bold())
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            ForEach(expenseViewModel.expenses) { item in
                // MARK: Transaction Card View
                TransactionCardView(expense: item).environmentObject(expenseViewModel)
            }
        }
        .padding(.top)
        
    }
    
}


struct HomeView_Preview:  PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
