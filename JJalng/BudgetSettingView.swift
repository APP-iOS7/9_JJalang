//
//  BudgetSettingView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI

struct BudgetSettingView: View {
    @State private var budget: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showAlert = false // 알림 표시를 위한 상태 변수 추가
    
    var body: some View {
        VStack {
            HStack {
                TextField("예산을 입력하세요", text: $budget)
                    .padding()
                    .frame(width: 250)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                Text("원")
                    .padding(.leading, 5) // 추가
            }
            
            // 날짜 선택을 위한 DatePicker 추가
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Button(action: {
                // 예산 입력 검증: 비어있거나 숫자가 아닌 경우 처리
                guard !budget.isEmpty, let budgetValue = Double(budget) else {
                    print("예산을 올바르게 입력해야 합니다.")
                    return
                }
                
                // 선택된 날짜 저장
                UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
                print("선택된 날짜: \(selectedDate)")
                
                // 예산 저장 로직
                UserDefaults.standard.set(budgetValue, forKey: "userBudget")
                print("예산이 설정되었습니다: \(budgetValue)")
                
                // 알림 표시
                showAlert = true
            }) {
                Text("저장")
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                // 예산 저장 완료 알림
                Alert(title: Text("저장 완료"), message: Text("예산이 설정되었습니다: \(budget) 원"), dismissButton: .default(Text("확인")))
            }
        }
        .padding()
        .navigationTitle("예산 설정")
    }
}

#Preview {
    BudgetSettingView()
}

