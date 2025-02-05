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
        moneyStatusList.first ?? MoneyStatus(amount: 0, budget: 0) // 기본값 설정
    }
    
    var body: some View {
        if let moneyStatus = moneyStatusList.first {
            let bindableMoneyStatus = Binding(get: { moneyStatus.amount }, set: { moneyStatus.amount = $0 })
            
            TabView {
                HomeView(moneyStatus: moneyStatus)
                    .tabItem {
                        Label("홈", systemImage: "house.fill")
                    }
                Calendar(amount: bindableMoneyStatus)
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
        let newMoneyStatus = MoneyStatus(amount: 0, budget: 0)
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
                // 예산 설정 화면
                Text("예산을 설정하세요")
                    .font(.title)
                    .padding()
                
                TextField("예산 입력 (₩)", text: $tempBudget)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if let value = Int(tempBudget), value > 0 {
                        moneyStatus.budget = value
                    }
                }) {
                    Text("설정 완료")
                        .padding()
                        .fontWeight(.bold)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                Spacer()
                Text("계획")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
                
                // 프로그레스 뷰
                ZStack {
                    // 배경 원 (전체 원)
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    // 진행 원 (잔고 원)
                    Circle()
                        .trim(from: 0, to: progressPercentage())
                        .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow, .green]), center: .center), lineWidth: 20)
                        .rotationEffect(.degrees(-90))  // 12시부터 시작
                        .frame(width: 200, height: 200)
                        .animation(.easeInOut(duration: 1), value: moneyStatus.amount)
                    
                    Spacer()
                    
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
                
                // 지출/수입 추가 버튼
                Button(action: {
                    moneyStatus.amount += 50000
                    try? modelContext.save() // 변경 사항 저장
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
        .modelContainer(for: [MoneyStatus.self, BuyHistory.self], inMemory: true)
}
