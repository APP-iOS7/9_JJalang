//
//  BuyHistory.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftData
import Foundation

@Model
final class BuyHistory: Identifiable {
    var id: String = UUID().uuidString
    var memo: String = ""
    var category: String? = ""
    var date: Date?
    var createAt: Date?
    var amount: Int = 0
    var budget: Int = 0
    
    init(memo: String, category: String? = nil, date: Date? = nil, createAt: Date? = nil,amount: Int = 0, budget: Int = 0) {
        self.memo = memo
        self.category = category
        self.date = date
        self.createAt = createAt
        self.amount = amount
        self.budget = budget
    }
}
