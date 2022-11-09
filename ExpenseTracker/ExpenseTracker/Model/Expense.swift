//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Dylan on 02/11/2022.
//

import Foundation
import SwiftUI

struct Expense: Identifiable, Hashable {
    var id = UUID().uuidString
    var remark: String
    var amount: Double
    var date: Date
    var color: String
    var type: ExpenseType
}

enum ExpenseType: String {
    case all = "all"
    case income = "income"
    case expense = "expense"
}

var sample_expenses: [Expense] = [
    Expense(remark: "Magic Keyboard", amount: 99, date: Date(timeIntervalSince1970: 1652987245), color: "Yellow", type: .expense),
    Expense(remark: "Food", amount: 19, date: Date(timeIntervalSince1970: 1652814445), color: "Purple", type: .expense),
    Expense(remark: "Magic Trackpad", amount: 99, date: Date(timeIntervalSince1970: 1652382445), color: "Green", type: .expense),
    Expense(remark: "Grab", amount: 29, date: Date(timeIntervalSince1970: 1652987245), color: "Green", type: .expense),
    Expense(remark: "Amazone Purchase", amount: 149, date: Date(timeIntervalSince1970: 1652987245), color: "Gray", type: .expense),
    Expense(remark: "Freelance", amount: 480, date: Date(timeIntervalSince1970: 1652987245), color: "Green", type: .income),
]
