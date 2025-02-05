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
    private let modelContainer: ModelContainer

    init() {
        do {
            // 모델 컨테이너 초기화
            modelContainer = try ModelContainer(for: MoneyStatus.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [MoneyStatus.self])
        }
    }
}
