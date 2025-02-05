//
//  MoneyStatus.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftData
import Foundation

@Model
final class MoneyStatus {
    var amount: Int
    var budget: Int

    init(amount: Int = 0, budget: Int = 0) {
        self.amount = amount
        self.budget = budget
    }
}
