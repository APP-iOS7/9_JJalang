//
//  CalendarView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftUI
import SwiftData

struct DateHeaderView: View {
    let selectedDate: Date
    let selectedDateTotal: Int
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var body: some View {
        HStack {
            Text(Self.dateFormatter.string(from: selectedDate))
                .font(.headline)
            Spacer()
            Text("일일 지출: ₩\(selectedDateTotal)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}

struct ExpenseRow: View {
    let memo: String
    let amount: Int
    
    var body: some View {
        HStack {
            Text("₩\(amount)")
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Text(memo)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}

struct ExpenseSection: View {
    @Binding var moneyStatus: MoneyStatus
    let money: MoneyStatus
    
    var body: some View {
        Section {
            ForEach(Array(money.amount.enumerated()), id: \.element.id) { index, amount in
                NavigationLink {
                    DetailView(
                        moneyStatus: $moneyStatus,
                        selectedAmount: binding(for: amount)
                    )
                } label: {
                    ExpenseRow(memo: money.amount[index].memo, amount: amount.amount)
                }
            }
        }
    }
    
    private func binding(for amount: AmountInfo) -> Binding<AmountInfo> {
        guard let index = moneyStatus.amount.firstIndex(where: { $0.id == amount.id }) else {
            fatalError("Amount not found")
        }
        return $moneyStatus.amount[index]
    }
}

struct ExpenseListView: View {
    @Binding var moneyStatusList: [MoneyStatus]
    let filteredMoneyStatus: [MoneyStatus]
    
    var body: some View {
        List {
            if filteredMoneyStatus.isEmpty {
                Section {
                    Text("해당 날짜에 지출 내역이 없습니다.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                }
            } else {
                ForEach(Array(filteredMoneyStatus.enumerated()), id: \.element.id) { index, money in
                    ExpenseSection(
                        moneyStatus: binding(for: money),
                        money: money
                    )
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private func binding(for money: MoneyStatus) -> Binding<MoneyStatus> {
        guard let index = moneyStatusList.firstIndex(where: { $0.id == money.id }) else {
            fatalError("Money status not found")
        }
        return $moneyStatusList[index]
    }
}

struct TotalAmountView: View {
    let totalSpent: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("총 지출")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("₩\(totalSpent)")
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .shadow(radius: 2)
    }
}

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @Query private var moneyStatusList: [MoneyStatus]
    @Environment(\.modelContext) private var modelContext
    
    var totalSpent: Int {
        moneyStatusList.flatMap { $0.amount }.reduce(0) { $0 + $1.amount }
    }
    
    // 기존 코드는 매 MoneyStatus 요소에 대해 상수 값을 반환했으므로 수정합니다.
    var filteredMoneyStatus: [MoneyStatus] {
        moneyStatusList.filter { money in
            Calendar.current.isDate(money.date, inSameDayAs: selectedDate)
        }
    }
    
    var selectedDateTotal: Int {
        filteredMoneyStatus.flatMap { $0.amount }.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
                .environment(\.locale, Locale(identifier: "ko"))
                .accessibilityLabel("지출 내역 날짜 선택")
            
            DateHeaderView(selectedDate: selectedDate, selectedDateTotal: selectedDateTotal)
            
            ExpenseListView(
                moneyStatusList: .init(
                    get: { self.moneyStatusList },
                    set: { newValue in }
                ),
                filteredMoneyStatus: filteredMoneyStatus
            )
            
            TotalAmountView(totalSpent: totalSpent)
        }
        .navigationTitle("캘린더")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CalendarView()
}
