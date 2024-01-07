//
//  FilterTransactionView.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 07/01/2024.
//

import SwiftUI
import SwiftData

struct FilterTransactionView<Content: View>: View {
    var content: ([Transaction]) -> Content
    @Query(animation: .snappy) private var transaction: [Transaction]
    
    init(category: Category?, searchText: String, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        /// Custom Predicate
        
        let rawValue = category?.rawValue ?? ""
            
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.title.localizedStandardContains(searchText) || transaction.remarks.localizedStandardContains(searchText)) &&
            (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transaction = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy)
        
        self.content = content
    }
    
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        /// Custom Predicate
        let predicate = #Predicate<Transaction> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
        }
        
        _transaction = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy)
        
        self.content = content
    }
    
    /// Optional For Customized Usage
    init(startDate: Date, endDate: Date, category: Category?, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        /// Custom Predicate
        
        let rawValue = category?.rawValue ?? ""
        
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.dateAdded >= startDate && transaction.dateAdded <= endDate) && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transaction = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy)
        
        self.content = content
    }
    
    var body: some View {
        content(transaction)
    }
}

