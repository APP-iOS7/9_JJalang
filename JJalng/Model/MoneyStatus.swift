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
    var id: UUID  // ✅ 수동으로 UUID 추가
    var memo: String
    var category: String?
    var date: Date
    var amount: [Int]
    var budget: Int

    init(memo: String, category: String? = nil, date: Date, amount: [Int] = [], budget: Int) {
        self.id = UUID()  // ✅ 고유한 ID 자동 생성
        self.memo = memo
        self.category = category
        self.date = date
        self.amount = amount
        self.budget = budget
    }

    var totalSpent: Int {
            amount.reduce(0, +)  // ✅ 전체 사용 금액 계산
        }
        
        var remainingBudget: Int {
            budget - totalSpent
        }
}
