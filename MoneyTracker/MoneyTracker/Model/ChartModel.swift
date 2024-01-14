//
//  ChartModel.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 14/01/2024.
//

import Foundation

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    let date: Date
    var categories: [ChartCategory]
    var totalIncomes: Double
    var totalExpenses: Double
}

struct ChartCategory: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: Category
}
