//
//  NewExpenseView.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 06/01/2024.
//

import SwiftUI

struct NewExpenseView: View {
    /// Environment Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var editTransaction: Transaction?
    /// View Properties
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: Category = .expense
    
    /// Random Tint
    @State var tint: TintColor = tints.randomElement()!
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                /// Preview Transaction Card View
                TransactionCardView(transaction: .init(title: title.isEmpty ? "Title" : title, remarks: remarks.isEmpty ? "Remarks" : remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint))
                
                
                CustomSection("Title", hint: "Magic Keyboard", value: $title)
                CustomSection("Remarks", hint: "Apple Product!", value: $remarks)
                
                /// Amount & Category Check Box
                VStack(alignment: .leading, spacing: 10) {
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 15) {
                        HStack(spacing: 4) {
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.numberPad)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 130)
                        
                        /// Custom Check Box
                        CategoryCheckBox()
                        
                    }
                }
                
                /// Date Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                }
            }
            .padding(15)
        }
        .navigationTitle(editTransaction == nil ? "Add Transaction" : "Edit Transaction")
        .background(.gray.opacity(0.15))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: saveData)
            }
        }
        .onAppear {
            if let editTransaction = editTransaction {
                /// Load All Existing Data
                title = editTransaction.title
                dateAdded = editTransaction.dateAdded
                remarks = editTransaction.remarks
                amount = editTransaction.amount
                if let tintColor = editTransaction.tint {
                    self.tint = tintColor
                }
                
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
            }
        }
    }
    
    /// Saving Data
    private func saveData() {
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.dateAdded = dateAdded
            editTransaction?.tintColor = tint.color
            editTransaction?.category = category.rawValue
        } else {
            /// Saving Item to Swift Data
            let transaction = Transaction(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            
            context.insert(transaction)
        }
        /// Dismissing View
        dismiss()
    }
    
    @ViewBuilder
    func CustomSection(_ title: String, hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        }
    }
    
    /// Custom Check Box
    @ViewBuilder
    func CategoryCheckBox() -> some View {
        HStack(spacing: 10) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                HStack(spacing: 5) {
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                    }
                    
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    /// Number Formatter
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    NavigationStack {
        NewExpenseView()
    }
}
