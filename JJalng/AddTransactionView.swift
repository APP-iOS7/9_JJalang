//
//  AddTransactionView.swift
//  JJalang
//
//  Created by vKv on 2/5/25.
//

import SwiftUI

struct AddTransactionView: View {
    @State private var amount: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: String = "🍽️ 식비"
    @State private var isCategoryExpanded: Bool = false
    @State private var navigateToMemoInput:Bool = false
    @Binding var selectedTab: Int
    
let categories = [
        "🍽️ 식비",
        "🚗 교통",
        "🛍 쇼핑",
        "🎮 여가",
        "💰 저축",
        "📂 기타"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 상단 제목
                    Text("지출 추가")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    // 지출 항목 선택
                    VStack(alignment: .leading) {
                        Text("지출 항목")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            isCategoryExpanded.toggle()
                        }) {
                            HStack {
                                Text(selectedCategory)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: isCategoryExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                        }
                        
                        if isCategoryExpanded {
                            VStack(spacing: 10) {
                                ForEach(categories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        isCategoryExpanded = false
                                    }) {
                                        HStack {
                                            Text(category)
                                                .foregroundColor(.black)
                                            Spacer()
                                            if selectedCategory == category {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                                    }
                                }
                            }
                            .padding(.top, 5)
                        }
                    }
                    
                    // 금액 입력 박스
                    VStack(alignment: .leading) {
                        Text("금액")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("원", text: $amount)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
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
                        }
                        .frame(height: 50)
                    }
                    
                    // 추가 버튼
                    Button(action: {
                        if let amountValue = Double(amount) {
                            print("지출 추가: \(amountValue)원, 카테고리: \(selectedCategory), 날짜: \(selectedDate)")
                            navigateToMemoInput = true //
                        }
                    }) {
                        Text("다음")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        //                        .shadow(color: .yellow.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToMemoInput) {
                MemoInputView(amount: amount, category: selectedCategory, date: selectedDate, selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    AddTransactionView(selectedTab: .constant(0))
}
