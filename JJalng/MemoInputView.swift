//
//  MemoInputView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI
import SwiftData

struct MemoInputView: View {
    let amount: String
    let category: String
    let date: Date
    
    @State private var memo: String = ""
    @Binding var selectedTab: Int
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            Text("메모 입력")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 20)
            
            TextEditor(text: $memo)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: saveTransaction) {
                Text("추가")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("메모 입력")
    }
    
    private func saveTransaction() {
        // 금액 문자열을 정수로 변환
        guard let amountValue = Int(amount) else { return }
        
        // 새 AmountInfo 객체 생성
        let newAmount = AmountInfo(amount: amountValue, memo: memo, category: category, date: date)
        
        // 기존 MoneyStatus 객체를 가져와서 새 거래 추가. 없으면 새 MoneyStatus를 생성합니다.
        if let existingMoneyStatus = try? modelContext.fetch(FetchDescriptor<MoneyStatus>()).first {
            existingMoneyStatus.amount.append(newAmount)
        } else {
            let newMoneyStatus = MoneyStatus(
                date: date,
                amount: [newAmount],
                budget: 0,      // 초기 예산 값 (필요에 따라 조정)
                targetTime: 1   // 초기 목표 기간 (필요에 따라 조정)
            )
            modelContext.insert(newMoneyStatus)
        }
        
        // 변경 사항 저장
        try? modelContext.save()
        
        // 홈 탭으로 전환 후 뷰 종료
        selectedTab = 0
        dismiss()
    }
}

#Preview {
    MemoInputView(amount: "10000", category: "🍽️ 식비", date: Date(), selectedTab: .constant(0))
}

