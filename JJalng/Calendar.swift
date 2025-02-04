import SwiftUI
import SwiftData

struct Calendar: View {
    
    @State private var selectedDate: Date = Date()
    @Binding var amount: Double
    @State private var inMoney: Int = 200000
    //    private var todosForSelectedDate: [TodoItem] {
    //        todos.filter { todo in
    //            todo.dueDate != nil ? Calendar.current.isDate(todo.dueDate!, inSameDayAs: selectedDate) : false
    //        }
    //    }
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
                        Text("총 지출 금액").font(.title2).foregroundStyle(.gray)
                        Text("₩ \(Int(amount))").font(.largeTitle).fontWeight(.bold)
                        Text("")
                        Text("총 수입 금액").font(.title2).foregroundStyle(.gray)
                        Text("₩ \(inMoney)").font(.largeTitle).fontWeight(.bold)
                        Text("")
                        Text(formatDate(selectedDate: selectedDate))
                    }
                    
                }
                
                //                List {
                //                    ForEach(todosForSelectedDate) { todo in
                //                        TodoRowView(todo: todo)
                //                    }
                //                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
