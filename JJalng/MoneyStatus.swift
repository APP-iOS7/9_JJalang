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
    var amount: Double
    var budget: Double
    
    init(amount: Double, budget: Double) {
        self.amount = amount
        self.budget = budget
    }
}
