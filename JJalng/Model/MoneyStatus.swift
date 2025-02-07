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
    var date: Date  // 예산 목표 기간을 설정했던 시점이 저장되는 변수 (ex. 2월 6일에 생성 -> 2월 6일 저장)
    var amount: [AmountInfo]
    var budget: Int
    var targetTime: Int // 예산 목표 기간 (BudgetSettingView 의 enum 연관값)

    init(date: Date,
         amount: [AmountInfo] = [],
         budget: Int,
         targetTime: Int) {
        self.date = date
        self.amount = amount
        self.budget = budget
        self.targetTime = targetTime
    }

    var totalSpent: Int {   // 전체 소비
        amount.reduce(0) { $0 + $1.amount }
    }
    
    var filteredAmount: [AmountInfo] {
        amount.filter { $0.date >= date && $0.date <= periodTime }
    }
    
    var filteredAmountByDate: [AmountInfo] {
        let calendar = Calendar.current
        return amount.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    // Date 에 targetTime 만큼을 더한 Date 변수
    // 시작일(목표 생성 날짜) 부터 periodTime 까지의 소비를 Circle로 구현
    var periodTime: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: targetTime, to: Date()) ?? Date()
    }

    // 포맷된 날짜 문자열 반환
    var formattedDate: String {
        return MoneyStatus.dateFormatter.string(from: date)
    }
    // 포맷된 목표날짜 문자열 반환
    var formattedperiodTime: String {
        return MoneyStatus.dateFormatter.string(from: periodTime)
    }
    
    var remainingBudget: Int {
        let totalFilteredSpent = filteredAmount.reduce(0) { $0 + $1.amount }
        return budget - totalFilteredSpent
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")  // 한국 로케일
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간 (KST)
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
}

@Model
class AmountInfo: Identifiable {
    var id: String = UUID().uuidString
    var amount: Int
    var memo: String
    var category: String?
    var date: Date  // 지출한 날짜

    init(amount: Int, memo: String = "", category: String? = nil, date: Date = Date()) {
        self.amount = amount
        self.memo = memo
        self.category = category
        self.date = date
    }
}
