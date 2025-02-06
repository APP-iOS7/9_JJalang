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
    var targetTime: Int // 예산 목표 기간 (BudgetSettingView 의 enum 연관값)



    init(memo: String,
         category: String? = nil,
         date: Date,
         amount: [AmountInfo] = [],
         budget: Int,
         targetTime: Int) {
        self.memo = memo
        self.category = category
        self.date = date
        self.amount = amount
        self.budget = budget
        self.targetTime = targetTime
    }

    var totalSpent: Int {   // 전체 소비
        amount.reduce(0) { $0 + $1.amount }
    }
    
    var remainingBudget: Int {
        budget - totalSpent
    }
    
    // Date 에 targetTime 만큼을 더한 Date 변수
    // 시작일(목표 생성 날짜) 부터 periodTime 까지의 소비를 Circle로 구현
    var periodTime: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: targetTime, to: Date()) ?? Date()
    }
}

//@Model
//final class AmountInfo {
//    var amount: Int
//    var category: String
//    var date: Date
//    
//    init(amount: Int, category: String, date: Date) {
//        self.amount = amount
//        self.category = category
//        self.date = date
//    }
//}

@Model
class AmountInfo: Identifiable {
    var id: String = UUID().uuidString
    var amount: Int
    var memo: String
    var category: String?
    var date: Date

    init(amount: Int, memo: String = "", category: String? = nil, date: Date = Date()) {
        self.amount = amount
        self.memo = memo
        self.category = category
        self.date = date
    }
}
