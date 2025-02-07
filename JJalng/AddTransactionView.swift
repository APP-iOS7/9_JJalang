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
    @State private var snackvarString: String = ""
    @State private var snackvarToggle: Bool = false
    @Binding var selectedTab: Int
    @Environment(\.dismiss) private var dismiss

    let categories = [
        "🍽️ 식비",
        "🚗 교통",
        "🛍 쇼핑",
        "🎮 여가",
        "💰 저축",
        "📂 기타"
    ]
    
    // NumberFormatter를 재사용하도록 computed property로 생성
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    // amountString에서 숫자만 추출하여 Int로 변환
    private var amount: Int? {
        let clean = amountString.filter { $0.isNumber }
        return Int(clean)
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
                            .onChange(of: amountString) { newValue in
                                // 입력된 문자열에서 숫자만 남깁니다.
                                let filtered = newValue.filter { $0.isNumber }
                                
                                // Int로 변환 가능하면 formatter를 적용한 문자열로 변경
                                if let number = Int(filtered),
                                   let formatted = numberFormatter.string(from: NSNumber(value: number)) {
                                    // formatted 값이 현재 입력과 다르면 업데이트
                                    if formatted != newValue {
                                        amountString = formatted
                                    }
                                } else {
                                    // 숫자로 변환 불가능하면 빈 문자열로 처리
                                    amountString = ""
                                }
                            }
                    }
                    
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
                    .padding(120)
                    
                HStack {
                    Button(action: {
                        if amount != nil {
                            navigateToMemoInput = true
                        }
                        else {
                            withAnimation {
                                snackvarToggle = true
                                snackvarString = "예산을 입력하세요."
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    snackvarToggle = false
                                }
                            }
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
                }
                .overlay(
                    VStack {
                        if snackvarToggle {
                            Text(snackvarString)
                                .fontWeight(.bold)
                                .padding()
                                .frame(minWidth: 300)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .opacity(snackvarToggle ? 1 : 0)
                                .offset(y: snackvarToggle ? 0 : 50)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: snackvarToggle)
                        }
                    }
                )                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToMemoInput) {
                MemoInputView(amount: amount ?? 0,
                              category: selectedCategory,
                              date: selectedDate,
                              selectedTab: $selectedTab,
                              dismissAction: { dismiss() })
            }
        }
    }

#Preview {
    AddTransactionView(moneyStatus: MoneyStatus(date: Date(), amount: [], budget: 0, targetTime: 1),
                       selectedTab: .constant(0))
        .modelContainer(for: MoneyStatus.self, inMemory: true)
}
