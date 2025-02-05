//
//  BudgetSettingView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI
import SwiftData

struct BudgetSettingView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var moneyStatusList: [MoneyStatus]
    
    var moneyStatus: MoneyStatus? {
        moneyStatusList.first
    }
    
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
    
    @State private var budget: String = ""
    @State private var selectedDate: Int = 0
    @State private var selectedOption: BudgetPeriod = .oneWeek

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("예산을 며칠동안 쓰시나요?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    Menu {
                        ForEach(BudgetPeriod.allCases, id: \.self) { option in
                            Button(option.rawValue) {
                                selectedOption = option
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(selectedOption.rawValue)
                                .font(.title2)
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
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
            Spacer()
            
            Text("목표 예산을 입력해 주세요.")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack(alignment: .trailing) {
                TextField("예산을 입력하세요", text: $budget)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: budget) {
                        budget = formatInput(budget)
                    }
                
                Text("₩")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.trailing)
            }
            .padding()
            
            Spacer()
            
            Button(action: saveBudget) {
                HStack {
                    Text("저장")
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
            
            Spacer()
        }
        .padding()
        .onAppear {
            if let money = moneyStatus {
                budget = formatInput("\(money.budget)")
            }
        }
    }
    
    private func saveBudget() {
        guard let money = moneyStatus else {
            print("저장할 데이터가 없습니다.")
            return
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.number(from: budget) {
            let newBudget = formattedNumber.intValue
            money.budget = newBudget
            try? modelContext.save()
            print("예산이 설정되었습니다: \(newBudget)")
        } else {
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
    BudgetSettingView()
}
