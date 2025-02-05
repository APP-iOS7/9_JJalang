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
    var selectedAmount: Binding<AmountInfo>?

    var body: some View {
        VStack {
            Text("지출 상세 내역")
                .font(.title)
                .padding()
            
            if let selectedAmount = selectedAmount {
                Text("선택된 금액: ₩ \(selectedAmount.wrappedValue.amount)")
                    .font(.title2)
                    .bold()
                    .padding()

                VStack(alignment: .leading, spacing: 20) {
                    TextField("메모", text: selectedAmount.memo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("카테고리", text: Binding(
                        get: { selectedAmount.wrappedValue.category ?? "" },
                        set: { selectedAmount.wrappedValue.category = $0.isEmpty ? nil : $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    DatePicker("날짜", selection: selectedAmount.date, displayedComponents: [.date])
                        .padding()
                }
            } else {
                Text("총 사용 금액: ₩ \(moneyStatus.totalSpent)")
                    .font(.largeTitle)
                    .bold()
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
        if let selectedAmount = selectedAmount {
            if let index = moneyStatus.amount.firstIndex(where: { $0.id == selectedAmount.wrappedValue.id }) {
                moneyStatus.amount.remove(at: index)
                try? modelContext.save()
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveChanges() {
        try? modelContext.save()
    }
}
