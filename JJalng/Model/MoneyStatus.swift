//
//  MoneyStatus.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftData
import Foundation

@Model
class MoneyStatus {
    var id: UUID
    var memo: String
    var category: String?
    var date: Date
    var amount: [AmountInfo]
    var budget: Int

    init(memo: String, category: String? = nil, date: Date, amount: [AmountInfo] = [], budget: Int) {
        self.id = UUID()
        self.memo = memo
        self.category = category
        self.date = date
        self.amount = amount
        self.budget = budget
    }

    var totalSpent: Int {
        amount.reduce(0) { $0 + $1.amount }
    }

    var remainingBudget: Int {
        budget - totalSpent
    }
}

@Model  // ✅ SwiftData에서 관리 가능하도록 @Model 추가
class AmountInfo: Identifiable {
    var id: UUID
    var amount: Int
    var memo: String
    var category: String?
    var date: Date

    init(amount: Int, memo: String = "", category: String? = nil, date: Date = Date()) {
        self.id = UUID()
        self.amount = amount
        self.memo = memo
        self.category = category
        self.date = date
    }
}
