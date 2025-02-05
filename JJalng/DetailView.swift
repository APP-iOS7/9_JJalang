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
    @Bindable var moneyStatus: MoneyStatus

    var body: some View {
        VStack {
            Text("지출 상세 내역")
                .font(.title)
                .padding()
            
            Text("총 사용 금액: ₩ \(moneyStatus.totalSpent)")
                .font(.largeTitle)
                .bold()
                .padding()
            
            List {
                ForEach(Array(moneyStatus.amount.enumerated()), id: \.offset) { index, amount in
                    HStack {
                        Text("₩ \(amount)")
                        Spacer()
                        Button(action: { deleteExpense(at: index) }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            // 폼 구성
            VStack(alignment: .leading, spacing: 20) {
                TextField("메모", text: $moneyStatus.memo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("카테고리", text: Binding(
                    get: { moneyStatus.category ?? "" },
                    set: { moneyStatus.category = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                DatePicker("날짜", selection: $moneyStatus.date, displayedComponents: [.date])
                .padding()
            }
            .padding()

            // 저장 버튼
            Button(action: saveChanges) {
                Text("저장")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
        .navigationBarTitle("지출 상세", displayMode: .inline)
        .onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // 변경사항 저장
    private func saveChanges() {
        try? modelContext.save()
    }
    
    // 지출 내역 삭제
    private func deleteExpense(at index: Int) {
        moneyStatus.amount.remove(at: index)  // 배열에서 해당 지출 삭제
        try? modelContext.save()
    }
}

//#Preview {
//    let container = try! ModelContainer(for: BuyHistory.self, inMemory: true)
//    let mockBuyHistory = BuyHistory(memo: "저녁식사", category: "식비", date: Date())
//    
//    container.mainContext.insert(mockBuyHistory)
//
//    return DetailView(buyHistory: mockBuyHistory)
//        .modelContainer(container)
//}
