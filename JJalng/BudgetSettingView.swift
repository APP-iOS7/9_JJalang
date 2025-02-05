//
//  BudgetSettingView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI

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
        
        /// 선택된 옵션에 따른 실제 일(day) 값
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
            HStack {
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
                        }
                        label: {
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
            }
            Spacer()
            Text("목표 예산을 입력해 주세요.")
                .font(.title)
                .fontWeight(.bold)
            ZStack (alignment: .trailing) {
                TextField("예산을 입력하세요", text: $budget)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: budget) {
                        formatInput(&budget)
                    }
                
                Text("₩")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.trailing)
            }
            .padding()
            
            Spacer()
            Button(action: {
                selectedDate = selectedOption.days
                
                // 예산 입력 검증: 비어있거나 숫자가 아닌 경우 처리
                
                guard !budget.isEmpty else {
                    print("예산을 입력해야 합니다.")
                    return
                }
                // 선택된 날짜 저장
                print("선택된 날짜: \(selectedDate)")
                
                // 예산 저장 로직
                print("예산이 설정되었습니다: \(budget)")
                
            }, label: {
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
            })
            Spacer()
        }
        .padding()
    }
    
    private func formatInput(_ text: inout String) {
        // 숫자만 남기기
        let filtered = text.filter { $0.isNumber }
        
        if let number = Int(filtered) {
            // 3자리마다 , 추가
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            text = formatter.string(from: NSNumber(value: number)) ?? ""
        } else {
            text = ""
        }
    }
}

#Preview {
    BudgetSettingView()
}

