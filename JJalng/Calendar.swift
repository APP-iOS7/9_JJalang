import SwiftUI
import SwiftData

struct Calendar: View {
    @State private var selectedDate: Date = Date()
    @Binding var amount: Int
    @State private var isShowingDetail = false
    
    private func formatDate(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .environment(\.locale, Locale(identifier: "ko"))
                
                List {
                    VStack(alignment: .leading) {
                        Text(formatDate(selectedDate: selectedDate))
                        Text("")
                        
                        Text("총 지출 금액")
                            .font(.title2)
                            .foregroundStyle(.gray)
                        
                        Text("₩ \(amount)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .onTapGesture {
                                isShowingDetail = true
                            }
                    }
                    .contentShape(Rectangle()) // 터치 영역 확장
                    .background(
                        NavigationLink(
                            destination: DetailView(
                                buyHistory: BuyHistory(memo: "샘플 지출", category: "기타", date: selectedDate)
                            ),
                            isActive: $isShowingDetail
                        ) {
                            EmptyView()
                        }
                            .opacity(0)
                    )
                }
            }
            .navigationTitle("달력")
        }
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var amount: Int = 1000  // ✅ @State로 값을 저장
        
        var body: some View {
            Calendar(amount: $amount)  // ✅ $ 붙여서 Binding 전달
        }
    }
    
    return PreviewWrapper()
}
