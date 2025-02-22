//
//  BudgetSettingView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI
import SwiftData

struct UpdateBudgetView: View {
    enum BudgetPeriod: String, CaseIterable {
        case oneWeek = "1주"
        case twoWeeks = "2주"
        case halfMonth = "15일"
        case oneMonth = "1개월"
        case twoMonths = "2개월"
        case threeMonths = "3개월"
        case sixMonths = "6개월"
        case oneYear = "1년"
        
        var days: Int {
            switch self {
            case .oneWeek: return 7
            case .twoWeeks: return 14
            case .halfMonth: return 15
            case .oneMonth: return 30
            case .twoMonths: return 60
            case .threeMonths: return 90
            case .sixMonths: return 180
            case .oneYear: return 365
            }
        }
    }
    
    @State private var budget: Int = 0
    @State private var date: Date
    @State private var targetTime: Int = 0
    @State private var budgetString: String = ""
    @State private var selectedDate: Int = 0
    @State private var selectedOption: BudgetPeriod = .oneWeek
    @State private var snackvarString: String = ""
    @State private var snackvarToggle: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Query private var moneyStatusList: [MoneyStatus]
    
    let moneyStatus: MoneyStatus
    
    init(moneyStatus: MoneyStatus) {
        self.moneyStatus = moneyStatus
        self._budget = State(initialValue: moneyStatus.budget)
        self._date = State(initialValue: moneyStatus.date)
        self._targetTime = State(initialValue: moneyStatus.targetTime)
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("목표 예산 수정")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack(alignment: .trailing) {
                TextField("\(moneyStatus.budget)", text: $budgetString)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: budgetString) {
                        budgetString = formatInput(budgetString)
                    }
                
                Text("₩")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.trailing)
            }
            .padding()
            
            HStack {
                Button(action: editBudget) {
                    HStack {
                        Text("수정")
                            .frame(minWidth: 300)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .frame(width: 400)
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
                    //                , alignment: .bottom
                )
            }
            
            
            Spacer()
            
            VStack {
                Text("기간을 새로 갱신")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    Menu {
                        ForEach(BudgetPeriod.allCases, id: \.self) { option in
                            Button(option.rawValue) {
                                selectedOption = option
                                targetTime = option.days
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(selectedOption.rawValue)
                                .font(.title2)
                                .foregroundStyle(.black)
                            //                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.black)
                        }
                        .frame(width: 100)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    Text("동안").font(.title)
                }
                
            }
            Button(action: editTargetTime) {
                HStack {
                    Text("수정")
                        .frame(minWidth: 300)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .frame(width: 400)
            }
            Text("기간을 수정하면 시작일이 새롭게 시작됩니다.")
                .font(.caption)
                .padding()
            Spacer()
        }
        .padding()
    }
    
    // 기간을 새로 갱신하면 moneyStatus.date도 현재 시간으로 설정되며, 새로운 목표 기간(홈 화면의 Circle)이 시작 된다.
    private func editTargetTime() {
        defer {
            dismiss()
        }
        moneyStatus.targetTime = targetTime
        moneyStatus.date = Calendar.current.startOfDay(for: Date()) // 오늘 날짜의 00:00:00 를 저장
        try? modelContext.save()
        print("목표기간이 수정되었습니다: \(targetTime)")
    }
    
    
    private func editBudget() {
//        defer {
//            dismiss()
//        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNumber = formatter.number(from: budgetString)
        let newBudget = formattedNumber?.intValue ?? 0
        if newBudget > 0 {
            moneyStatus.budget = newBudget
            try? modelContext.save()
            print("예산이 설정되었습니다: \(newBudget)")
            dismiss()
        } else {
            withAnimation {
                snackvarToggle = true
                snackvarString = "예산을 입력하세요."
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    snackvarToggle = false
                }
            }
            print("유효한 숫자가 아닙니다.")
        }
    }
    
    private func formatInput(_ text: String) -> String {
        let filtered = text.filter { $0.isNumber }
        
        if let number = Int(filtered) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: number)) ?? ""
        } else {
            return ""
        }
    }
}

#Preview {
    UpdateBudgetView(moneyStatus: MoneyStatus(date: Date.now, budget: 0, targetTime: 1))
}
