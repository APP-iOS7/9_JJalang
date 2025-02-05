//
//  ContentView.swift
//  JJalng
//
//  Created by 장새벽 on 2/4/25

//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var moneyStatusList: [MoneyStatus]
    @Environment(\.modelContext) private var modelContext
    
    var moneyStatus: MoneyStatus {
        moneyStatusList.first ?? MoneyStatus(memo: "", date: Date(), amount: 0, budget: 0)
    }
    
    var body: some View {
        if let moneyStatus = moneyStatusList.first {
            TabView {
                HomeView(moneyStatus: moneyStatus)
                    .tabItem {
                        Label("홈", systemImage: "house.fill")
                    }
                CalendarView()
                    .tabItem {
                        Label("달력", systemImage: "calendar")
                    }
            }
        } else {
            Text("데이터를 불러오는 중...")
                .onAppear {
                    addInitialMoneyStatus()
                }
        }
    }
    
    private func addInitialMoneyStatus() {
        let newMoneyStatus = MoneyStatus(memo: "", date: Date(), amount: 0, budget: 0)
        modelContext.insert(newMoneyStatus)
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    var moneyStatus: MoneyStatus
    @State private var tempBudget: String = ""
    
    var body: some View {
        VStack {
            if moneyStatus.budget == 0 {
                BudgetSettingView()
            } else {
                Spacer()
                Text("계획")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: progressPercentage())
                        .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow, .green]), center: .center), lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 200, height: 200)
                        .animation(.easeInOut(duration: 1), value: moneyStatus.amount)
                    
                    VStack {
                        Text("이번 달 사용 금액")
                            .font(.headline)
                        Text("₩ \(moneyStatus.amount)")
                            .font(.title)
                            .bold()
                            .padding(.top, 10)
                    }
                }
                .padding()
                
                Text("/ ₩ \(moneyStatus.budget)")
                    .foregroundColor(.gray)
                Spacer()
                
                Button(action: {
                    moneyStatus.amount += 50000
                    try? modelContext.save()
                }) {
                    Text("지출 추가")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
        .padding()
    }
    
    func progressPercentage() -> CGFloat {
        return CGFloat(min(Double(moneyStatus.amount) / Double(moneyStatus.budget), 1.0))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [MoneyStatus.self], inMemory: true)

}
