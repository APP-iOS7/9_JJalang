//
//  ContentView.swift
//  JJalng
//
//  Created by 장새벽 on 2/4/25
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var amount: Double = 0    // 현재 잔고
    @State private var budget: Double = 0  // 목표 잔고 (저장됨)
    @State private var tempBudget: String = ""
    
    var body: some View {
        TabView {
            HomeView(amount: $amount, budget: $budget)
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
            
            DetailView(amount: amount)
                .tabItem {
                    Label("상세 내역", systemImage: "list.bullet")
                }
        }
    }
}

struct HomeView: View {
    @Binding var amount: Double
    @Binding var budget: Double
    @State private var tempBudget: String = ""
    
    var body: some View {
        VStack {
            if budget == 0 {
                // 예산 설정 화면
                Text("예산을 설정하세요")
                    .font(.title)
                    .padding()
                
                TextField("예산 입력 (₩)", text: $tempBudget)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if let value = Double(tempBudget), value > 0 {
                        budget = value
                    }
                }) {
                    Text("설정 완료")
                        .padding()
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
                        .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow]), center: .center), lineWidth: 20)
                        .rotationEffect(.degrees(-90))  // 12시부터 시작
                        .frame(width: 200, height: 200)
                        .animation(.easeInOut(duration: 1), value: amount)
                    
                    Spacer()
                    
                    VStack {
                        Text("이번 달 사용 금액")
                            .font(.headline)
                        Text("₩ \(Int(amount))")
                            .font(.title)
                            .bold()
                            .padding(.top, 10)
                    }
                }
                .padding()
                
                Text("/ ₩ \(Int(budget))")
                    .foregroundColor(.gray)
                
                Spacer()
                
                // 지출/수입 추가 버튼
                Button(action: {
                    // 50000원씩 증가
                    amount += 50000
                }) {
                    Text("지출/수입 추가")
                        .fontWeight(.heavy)
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
        return CGFloat(min(amount / budget, 1.0))
    }
}

struct DetailView: View {
    var amount: Double
    
    var body: some View {
        VStack {
            Text("상세 내역")
                .font(.largeTitle)
                .padding()
            
            Text("이번 달 사용 금액: ₩ \(Int(amount))")
                .font(.title)
                .padding()
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
