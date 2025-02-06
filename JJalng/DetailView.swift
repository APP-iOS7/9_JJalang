//
//  SwiftUIView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Binding var moneyStatus: MoneyStatus
    @Binding var selectedAmount: AmountInfo

    var body: some View {
        VStack {
            Text("지출 상세 내역")
                .font(.title)
                .padding()
            
            // 선택된 Amount 정보 표시
            Text("선택된 금액: ₩ \(selectedAmount.amount)")
                .font(.title2)
                .bold()
                .padding()

            VStack(alignment: .leading, spacing: 20) {
                // 메모 수정
                TextField("메모", text: $selectedAmount.memo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // 카테고리 수정
                TextField("카테고리", text: Binding(
                    get: { selectedAmount.category ?? "" },
                    set: { selectedAmount.category = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // 날짜 수정
                DatePicker("날짜", selection: $selectedAmount.date, displayedComponents: [.date])
                    .padding()
            }

            HStack {
                Button(action: saveChanges) {
                    Text("저장")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: deleteSelectedAmount) {
                    Text("삭제")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.top)
        }
        .padding()
        .navigationBarTitle("지출 상세", displayMode: .inline)
    }
    
    private func deleteSelectedAmount() {
        if let index = moneyStatus.amount.firstIndex(where: { $0.id == selectedAmount.id }) {
            moneyStatus.amount.remove(at: index)
            try? modelContext.save()
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveChanges() {
        // 선택한 거래의 날짜를 하루 단위로 맞춥니다.
        let newTransactionDate = Calendar.current.startOfDay(for: selectedAmount.date)
        let currentContainerDate = Calendar.current.startOfDay(for: moneyStatus.date)

        // 거래 날짜가 컨테이너 날짜와 다르면 이동 로직 실행
        if newTransactionDate != currentContainerDate {
            // 1. 현재 컨테이너에서 해당 거래 제거
            if let index = moneyStatus.amount.firstIndex(where: { $0.id == selectedAmount.id }) {
                moneyStatus.amount.remove(at: index)
            }
            
            // 2. 새로운 날짜에 해당하는 MoneyStatus 컨테이너 검색 (SwiftData 전용 Predicate 사용)
            let predicate: Predicate<MoneyStatus>? = #Predicate { money in
                money.date == newTransactionDate
            }
            let fetchDescriptor = FetchDescriptor<MoneyStatus>(predicate: predicate)
            
            if let targetContainer = try? modelContext.fetch(fetchDescriptor).first {
                // 해당 날짜의 컨테이너가 있으면 거래 추가
                targetContainer.amount.append(selectedAmount)
            } else {
                // 없으면 새 컨테이너 생성
                let newContainer = MoneyStatus(
                    memo: "",
                    date: newTransactionDate,
                    amount: [selectedAmount],
                    budget: moneyStatus.budget,
                    targetTime: moneyStatus.targetTime
                )
                modelContext.insert(newContainer)
            }
            
            // 현재 컨테이너에 거래가 남아있지 않으면 삭제 (선택 사항)
            if moneyStatus.amount.isEmpty {
                modelContext.delete(moneyStatus)
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("저장 실패: \(error)")
        }
        presentationMode.wrappedValue.dismiss()
    }
}
