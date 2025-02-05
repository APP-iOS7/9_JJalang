import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @Query private var moneyStatusList: [MoneyStatus]
    
    // 전체 지출 금액 계산
    var totalSpent: Int {
        moneyStatusList.reduce(0) { $0 + $1.amount.reduce(0, +) }
    }
    
    // 선택한 날짜의 지출 금액 계산
    var filteredMoneyStatus: [MoneyStatus] {
        moneyStatusList.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
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
                    if filteredMoneyStatus.isEmpty {
                        Text("해당 날짜에 지출 내역이 없습니다.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredMoneyStatus) { money in
                            NavigationLink(destination: DetailView(moneyStatus: money)) {
                                VStack(alignment: .leading) {
                                    Text(money.memo)
                                    Text("₩ \(money.amount.reduce(0, +))").font(.headline)  // 금액 합산
                                }
                            }
                        }
                    }
                }
                
                Text("지금까지 ₩ \(totalSpent) 쓰셨네요!")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding()
            }
        }
    }
}
