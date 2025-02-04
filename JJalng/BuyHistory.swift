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
    var id: UUID
    var memo: String
    var category: String?
    var date: Date?
    var createAt: Date?
    
    init(id: UUID = UUID(), memo: String, category: String? = nil, date: Date? = nil, createAt: Date? = nil) {
        self.id = id
        self.memo = memo
        self.category = category
        self.date = date
        self.createAt = createAt
    }
}
