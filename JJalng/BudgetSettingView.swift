//
//  BudgetSettingView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI
import SwiftData

struct BudgetSettingView: View {
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
    
    @State private var budget: Int
    @State private var date: Date
    @State private var targetTime: Int
    @State private var budgetString: String = ""
    @State private var selectedDate: Int = 0
    @State private var selectedOption: BudgetPeriod?
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
            
            Image("JJalang")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            Text("목표 예산")
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
                    .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 2) // 테두리 설정
                        )
                Text("₩")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.trailing)
            }
            .padding([.leading, .trailing], 40)
            
            
            Spacer()
            VStack() {
                Text("기간을 설정해주세요.")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                
                
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
                        Text(selectedOption?.rawValue ?? "기간 선택")
                            .font(.body)
                            .foregroundStyle(selectedOption?.rawValue == nil ? .gray : .black)
//                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.black)
                    }
                    .frame(width: 200)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            
            
            Spacer()
            Button(action: saveBudgetAndTargetTime) {
                HStack {
                    Text("확인")
                        .frame(minWidth: 300)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                .overlay(
                    VStack {
                        if snackvarToggle {
                            Text(snackvarString)
                                .fontWeight(.bold)
                                .padding()
                                .frame(minWidth: 300, maxWidth: .infinity)
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .opacity(snackvarToggle ? 1 : 0)
                                .offset(y: snackvarToggle ? 0 : 50)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: snackvarToggle)
                        }
                    }
                    , alignment: .bottom
                )

            }
        }
        .padding()
    }
    
    private func saveBudgetAndTargetTime() {
        defer {
            dismiss()
        }
        if selectedOption != nil {
            moneyStatus.targetTime = targetTime
            moneyStatus.date = Date()
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            if let formattedNumber = formatter.number(from: budgetString) {
                let newBudget = formattedNumber.intValue
                moneyStatus.budget = newBudget
                try? modelContext.save()
                print("예산이 설정되었습니다: \(newBudget)")
            } else {
                withAnimation {
                    snackvarToggle = true
                    snackvarString = "유효한 숫자가 아닙니다."
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        snackvarToggle = false
                    }
                }
                print("유효한 숫자가 아닙니다.")
            }
        } else {
            withAnimation {
                snackvarToggle = true
                snackvarString = "기간을 선택해 주세요."
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    snackvarToggle = false
                }
            }
            print("기간을 선택해 주세요.")
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
    BudgetSettingView(moneyStatus: MoneyStatus(date: Date.now, budget: 0, targetTime: 1))
}
