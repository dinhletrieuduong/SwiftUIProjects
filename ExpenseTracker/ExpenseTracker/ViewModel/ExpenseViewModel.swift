//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Dylan on 02/11/2022.
//

import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    // MARK: Properties
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var currentMonthStartDate: Date = Date()
    
    @Published var expenses: [Expense] = sample_expenses
    
    // MARK: Expense/ Income Tab
    @Published var tabName: ExpenseType = .expense
    
    // MARK: Filter View
    @Published var showFilterView: Bool = false
    
    // MARK: New Expense Properties
    @Published var addNewExpense: Bool = false
    @Published var amount: String = ""
    @Published var type: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var remark: String = ""
    
    
    init() {
        // MARK: Fetching Current Month Starting Date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        startDate = calendar.date(from: components)!
        currentMonthStartDate = calendar.date(from: components)!
    }
    
    // MARK: Fetching Current Month Date String
    func currentMonthDateString() -> String {
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + " - " + Date().formatted(date: .abbreviated, time: .omitted)
    }
    
    func convertExpensesToCurrency(expenses: [Expense], type: ExpenseType = .all) -> String {
        var sum: Double = 0
        sum = expenses.reduce(0, { partialResult, expense in
            return partialResult + (expense.type == .all ? (type == .income ? expense.amount : -expense.amount) : (expense.type == type ? expense.amount : 0))
        })
        return convertNumberToPrice(value: sum)
    }
    
    // MARK: Converting Number to Price
    func convertNumberToPrice(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: .init(value: value)) ?? "$0.00"
    }
    
    // MARK: Converting Selected Dates To String
    func convertDateToString() -> String {
        return startDate.formatted(date: .abbreviated, time: .omitted) + " - " + endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    // MARK: Clearing all data
    func clearData() {
        date = Date()
        type = .all
        remark = ""
        amount = ""
    }
    
    // MARK: Save Data
    func saveData(env: EnvironmentValues) {
        let amountInDouble = (amount as NSString).doubleValue
        let colors = ["Yellow", "Red", "Purple", "Green"]
        let expense = Expense(remark: remark, amount: amountInDouble, date: date, color: colors.randomElement() ?? "Yellow", type: type)
        withAnimation {
            expenses.append(expense)
        }
        expenses = expenses.sorted(by: { first, second in
            return second.date < first.date
        })
        env.dismiss()
    }
}
