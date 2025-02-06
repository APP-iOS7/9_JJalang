//
//  SwiftUIView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

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
    @Binding var selectedAmount: AmountInfo
    @State private var showDatePickerSheet: Bool = false
    private let categories = ["🍽️ 식비", "🚗 교통", "🛍 쇼핑", "🎮 여가", "💰 저축", "📂 기타"]
    
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
                
                // CategoryPickerView 사용
                CategoryPickerView(categories: categories,
                                   selectedCategory: Binding(
                                    get: { selectedAmount.category ?? "" },
                                    set: { selectedAmount.category = $0 }
                                   ))
                .padding()
                
                HStack {
                    Text(dateFormatter(date: selectedAmount.date))
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
        // 날짜 선택 sheet
        .sheet(isPresented: $showDatePickerSheet) {
            VStack {
                DatePicker("날짜 선택", selection: $selectedAmount.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .environment(\.locale, Locale(identifier: "ko"))
                    .onChange(of: selectedAmount.date) { newValue, transaction in
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
        do {
            try modelContext.save()
        } catch {
            print("저장 실패: \(error)")
        }
        presentationMode.wrappedValue.dismiss()
    }
}
