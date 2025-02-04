//
//  SwiftUIView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    var moneyStatus: MoneyStatus  // 재정 상태
    var buyHistory: BuyHistory  // 지출 내역
    
    @State private var memo: String
    @State private var category: String?
    @State private var date: Date?
    
    init(moneyStatus: MoneyStatus, buyHistory: BuyHistory) {
        self.moneyStatus = moneyStatus
        self.buyHistory = buyHistory
        _memo = State(initialValue: buyHistory.memo)
        _category = State(initialValue: buyHistory.category)
        _date = State(initialValue: buyHistory.date)
    }
    
    var body: some View {
        VStack {
            Text("지출 내역")
                .font(.title)
                .padding()
            
            Text("₩ \(Int(moneyStatus.amount))")
                .font(.largeTitle)
                .bold()
                .padding()

            // 폼 구성
            VStack(alignment: .leading, spacing: 20) {
                TextField("메모", text: $memo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("카테고리", text: Binding(
                    get: { category ?? "" },
                    set: { category = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                DatePicker("날짜", selection: Binding(
                    get: { date ?? Date() },
                    set: { date = $0 }
                ), displayedComponents: [.date])
                .padding()
            }
            .padding()

            // 저장 및 삭제 버튼
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
                .padding(.top)

                Button(action: deleteHistory) {
                    Text("삭제")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
        }
        .padding()
        .navigationBarTitle("지출 상세", displayMode: .inline)
    }
    
    // 변경사항 저장
    func saveChanges() {
        buyHistory.memo = memo
        buyHistory.category = category
        buyHistory.date = date
    }
    
    // 지출 내역 삭제
    func deleteHistory() {
        // 실제로 삭제할 때는 DB나 저장소에서 삭제하는 코드를 추가
        print("지출 내역 삭제: \(buyHistory.id)")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        // 더미 데이터 생성
        let mockMoneyStatus = MoneyStatus(amount: 100000)
        let mockBuyHistory = BuyHistory(memo: "저녁식사", category: "식비", date: Date())
        
        // DetailView에 더미 데이터를 전달
        DetailView(moneyStatus: mockMoneyStatus, buyHistory: mockBuyHistory)
    }
}
