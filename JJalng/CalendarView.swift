import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @Query private var moneyStatusList: [MoneyStatus]
    
    // 총 지출 금액을 계산하는 부분을 나눔
    var totalSpent: Int {
        let allAmounts = moneyStatusList.flatMap { $0.amount } // 금액 리스트를 평평하게 만듦
        var total = 0
        for amount in allAmounts {
            total += amount.amount
        }
        return total
    }
    
    // 선택된 날짜에 해당하는 지출 내역을 필터링
    var filteredMoneyStatus: [MoneyStatus] {
        let calendar = Calendar.current
        var filtered: [MoneyStatus] = []
        
        // 날짜에 맞는 지출 내역만 필터링
        for money in moneyStatusList {
            if calendar.isDate(money.date, inSameDayAs: selectedDate) {
                filtered.append(money)
            }
        }
        return filtered
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .environment(\.locale, Locale(identifier: "ko"))
                
                List {
                    Text(formatDate(selectedDate)) // 날짜 포맷 표시
                    if filteredMoneyStatus.isEmpty {
                        Text("해당 날짜에 지출 내역이 없습니다.")
                            .foregroundColor(.gray)
                        } else {
                            
                            
                    }
                    
                    Text("지금까지 ₩ \(totalSpent) 쓰셨네요!")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding()
                }
            }
        }
    }
}
