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
    @State private var showDatePickerSheet: Bool = false

    var body: some View {
        VStack {
            Text("지출 상세 내역")
                .font(.title)
                .padding()
            
            Text("선택된 금액: ₩ \(selectedAmount.amount)")
                .font(.title2)
                .bold()
                .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                TextField("메모", text: $selectedAmount.memo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("카테고리", text: Binding(
                    get: { selectedAmount.category ?? "" },
                    set: { selectedAmount.category = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                HStack {
                    Spacer()
                    Button(action: {
                        showDatePickerSheet = true
                    }) {
                        Text("날짜 변경")
                            .fontWeight(.bold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
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
        .sheet(isPresented: $showDatePickerSheet) {
            VStack {
                DatePicker("날짜 선택", selection: $selectedAmount.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .environment(\.locale, Locale(identifier: "ko"))
                    .onChange(of: selectedAmount.date) { _ in
                        showDatePickerSheet = false
                    }
                
                Button("닫기") {
                    showDatePickerSheet = false
                }
                .padding()
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    private func deleteSelectedAmount() {
        if let index = moneyStatus.amount.firstIndex(where: { $0.id == selectedAmount.id }) {
            moneyStatus.amount.remove(at: index)
            try? modelContext.save()
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveChanges() {
        let newTransactionDate = Calendar.current.startOfDay(for: selectedAmount.date)
        let currentContainerDate = Calendar.current.startOfDay(for: moneyStatus.date)
        
        if newTransactionDate != currentContainerDate {
            let transactionToMove = selectedAmount
            
            if let index = moneyStatus.amount.firstIndex(where: { $0.id == transactionToMove.id }) {
                moneyStatus.amount.remove(at: index)
            }
            
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: newTransactionDate)!
            let predicate: Predicate<MoneyStatus> = #Predicate { money in
                money.date >= newTransactionDate && money.date < nextDay
            }
            let fetchDescriptor = FetchDescriptor<MoneyStatus>(predicate: predicate)
            
            if let targetContainer = try? modelContext.fetch(fetchDescriptor).first {
                targetContainer.amount.append(transactionToMove)
            } else {
                let newContainer = MoneyStatus(
                    date: newTransactionDate,
                    amount: [transactionToMove],
                    budget: moneyStatus.budget,
                    targetTime: moneyStatus.targetTime
                )
                modelContext.insert(newContainer)
            }
            
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
