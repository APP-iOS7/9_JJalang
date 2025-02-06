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
                TextField("메모", text: $selectedAmount.memo) // Binding으로 메모 수정
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
        do {
            try modelContext.save()
        } catch {
            print("저장 실패: \(error)")
        }
        presentationMode.wrappedValue.dismiss()
    }
}
