//
//  MoneyStatus.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftData
import Foundation

@Model
final class MoneyStatus: Identifiable {
    var amount: Double
    var budget: Double

    init(amount: Double = 0.0, budget: Double = 0.0) {
        self.amount = amount
        self.budget = budget
    }
}
