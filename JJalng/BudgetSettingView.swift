//
//  BudgetSettingView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI

struct BudgetSettingView: View {
    @State private var budget: String = ""
    @State private var selectedDate: Date = Date() // 날짜 선택을 위한 상태 변수 추가
    
    var body: some View {
        VStack {
            TextField("예산을 입력하세요", text: $budget)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // 날짜 선택을 위한 DatePicker 추가
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle()) // 그래픽 스타일로 설정
                .padding()
            
            Button(action: {
                // 선택된 날짜 저장
                UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
                print("선택된 날짜: \(selectedDate)")
                
                // 예산 저장 로직
                if let budgetValue = Double(budget) {
                    UserDefaults.standard.set(budgetValue, forKey: "userBudget") // "userBudeget"를 "userBudget"로 수정
                    print("예산이 설정되었습니다: \(budgetValue)")
                }
            }) {
                Text("저장")
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("예산 설정")
    }
}

#Preview {
    BudgetSettingView()
}
