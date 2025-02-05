import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @Query private var moneyStatusList: [MoneyStatus]  // ✅ SwiftData에서 데이터 가져오기

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    /// ✅ 선택한 날짜의 MoneyStatus 데이터 필터링
    var filteredMoneyStatus: [MoneyStatus] {
        moneyStatusList.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    /// ✅ 선택한 날짜의 총 지출 금액 계산
    var totalSpent: Int {
        filteredMoneyStatus.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                /// ✅ 날짜 선택
                DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .environment(\.locale, Locale(identifier: "ko"))
                
                /// ✅ 선택한 날짜의 지출 내역 표시
                List {
                    Text(formatDate(selectedDate))
                    if filteredMoneyStatus.isEmpty {
                        Text("해당 날짜에 지출 내역이 없습니다.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredMoneyStatus) { money in
                            NavigationLink(destination: DetailView(moneyStatus: money)) {
                                VStack(alignment: .leading) {
                                    Text(money.memo)
                                    Text("₩ \(money.amount)").font(.headline)
                                }
                            }
                        }
                    }
                }
                
                /// ✅ 총 지출 금액 표시
                Text("총 지출 금액: ₩ \(totalSpent)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
        }
    }
}

//#Preview {
//    struct PreviewWrapper: View {
//        @State private var amount: Int = 1000  // ✅ @State로 값을 저장
//        
//        var body: some View {
//            Calendar(amount: $amount)  // ✅ $ 붙여서 Binding 전달
//        }
//    }
//    
//    return PreviewWrapper()
//}
