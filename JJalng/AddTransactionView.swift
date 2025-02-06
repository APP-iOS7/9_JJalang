//
//  AddTransactionView.swift
//  JJalang
//
//  Created by vKv on 2/5/25.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var moneyStatus: MoneyStatus
    @State private var amountString: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: String = ""
    @State private var navigateToMemoInput: Bool = false
    @Binding var selectedTab: Int
    
    let categories = [
        "🍽️ 식비",
        "🚗 교통",
        "🛍 쇼핑",
        "🎮 여가",
        "💰 저축",
        "📂 기타"
    ]
    
    private var amount: Int? {
        let clean = amountString.filter { $0.isNumber }
        return Int(clean)
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("지출 추가")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    CategoryPickerView(categories: categories,
                                       selectedCategory: $selectedCategory)
                    //                    .padding()
                    
                    // 금액 입력 박스
                    VStack(alignment: .leading) {
                        Text("금액")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("원", text: $amountString)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                            .onChange(of: amountString) { newValue, _ in
                                let filtered = newValue.filter { $0.isNumber }
                                guard let number = Int(filtered) else {
                                    amountString = ""
                                    return
                                }
                                if let formatted = numberFormatter.string(from: NSNumber(value: number)) {
                                    if formatted != newValue {
                                        amountString = formatted
                                    }
                                }
                            }
                    }
                    
                    // 날짜 선택 박스
                    VStack(alignment: .leading) {
                        Text("날짜")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                                .padding(.horizontal)
                                .tint(.green)
                        }
                        .frame(height: 50)
                    }
                }
                    Spacer()
                    
                    // 추가 버튼
                    Button(action: {
                        if amount != nil {
                            navigateToMemoInput = true
                        }
                    }) {
                        Text("다음")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
//                    .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToMemoInput) {
                MemoInputView(amount: amount ?? 0,
                              category: selectedCategory,
                              date: selectedDate,
                              selectedTab: $selectedTab)
            }
        }
    }

#Preview {
    AddTransactionView(moneyStatus: MoneyStatus(date: Date(), amount: [], budget: 0, targetTime: 1),
                       selectedTab: .constant(0))
    .modelContainer(for: MoneyStatus.self, inMemory: true)
}
