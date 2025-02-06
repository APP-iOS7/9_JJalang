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
    var id: String = UUID().uuidString
    var memo: String
    var category: String?
    var date: Date
    var amount: [AmountInfo]
    var budget: Int
    var totalSpent: Int {
        amount.reduce(0) { $0 + $1.amount }
    }

    init(memo: String, category: String? = nil, date: Date, amount: [AmountInfo] = [], budget: Int) {
        self.memo = memo
        self.category = category
        self.date = date
        self.amount = amount
        self.budget = budget
    }

//    var totalSpent: Int {   // 전체 소비
//        amount.reduce(0) { $0 + $1.amount }
//    }

//    var remainingBudget: Int {  
//        budget - totalSpent
//    }
}

@Model
final class AmountInfo {
    var amount: Int
    var category: String
    var date: Date
    
    init(amount: Int, category: String, date: Date) {
        self.amount = amount
        self.category = category
        self.date = date
    }
}

//@Model
//class AmountInfo: Identifiable {
//    var id: String = UUID().uuidString
//    var amount: Int
//    var memo: String
//    var category: String?
//    var date: Date
//
//    init(amount: Int, memo: String = "", category: String? = nil, date: Date = Date()) {
//        self.amount = amount
//        self.memo = memo
//        self.category = category
//        self.date = date
//    }
//}
