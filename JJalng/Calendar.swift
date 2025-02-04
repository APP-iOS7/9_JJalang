import SwiftUI
import SwiftData

struct Calendar: View {
    
    @State private var selectedDate: Date = Date()
    @Binding var amount: Int

    private func formatDate(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: selectedDate)
    }
    var body: some View {

        NavigationStack {
            VStack(alignment: .leading) {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .environment(\.locale, Locale.init(identifier: "ko"))
                List {
                    VStack(alignment: .leading) {
                        Text(formatDate(selectedDate: selectedDate))
                        Text("")

                        Text("총 지출 금액").font(.title2).foregroundStyle(.gray)
                        Text("₩ \(Int(amount))").font(.largeTitle).fontWeight(.bold)
                    }
                    
                }
            }
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
