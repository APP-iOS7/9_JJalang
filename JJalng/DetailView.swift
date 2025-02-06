//
//  DetailView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    var selectedAmount: AmountInfo  // @Binding 제거
    @State private var amount: Int
    @State private var memo: String
    @State private var category: String?
    @State private var date: Date
    @State private var showDatePickerSheet: Bool = false

    init(selectedAmount: AmountInfo) {
        self.selectedAmount = selectedAmount
        _amount = State(initialValue: selectedAmount.amount)
        _memo = State(initialValue: selectedAmount.memo)
        _category = State(initialValue: selectedAmount.category)
        _date = State(initialValue: selectedAmount.date)
    }

    var body: some View {
        VStack {
            Text("지출 상세 내역")
                .font(.title)
                .padding()
            
            Text("선택된 금액: ₩ \(amount)")
                .font(.title2)
                .bold()
                .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                TextField("메모", text: $memo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("카테고리", text: Binding(
                    get: { category ?? "" },
                    set: { category = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                HStack {
                    Text(dateFormatter(date: date))
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
                DatePicker("날짜 선택", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .environment(\.locale, Locale(identifier: "ko"))
                    .onChange(of: date) {
                        showDatePickerSheet = false
                    }
                    .tint(.green)
                
                Button("닫기") {
                    showDatePickerSheet = false
                }
                .padding()
            }
        }
    }
    
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }

    private func deleteSelectedAmount() {
        modelContext.delete(selectedAmount)
        try? modelContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveChanges() {
        selectedAmount.amount = amount
        selectedAmount.memo = memo
        selectedAmount.category = category
        selectedAmount.date = date
        
        do {
            try modelContext.save()
        } catch {
            print("저장 실패: \(error)")
        }
        presentationMode.wrappedValue.dismiss()
    }
}
