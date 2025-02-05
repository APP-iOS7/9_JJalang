//
//  JJalngApp.swift
//  JJalng
//
//  Created by 김동영 on 2/4/25.
//

import SwiftUI
import SwiftData

@main
struct JJalngApp: App {
    private let modelContainer = try! ModelContainer(for: BuyHistory.self)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
