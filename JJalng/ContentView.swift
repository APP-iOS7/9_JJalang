
import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var moneyStatusList: [MoneyStatus]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    var moneyStatus: MoneyStatus? {
        moneyStatusList.first
    }
    var body: some View {
        NavigationStack {
            if let moneyStatus = moneyStatusList.first {
                if moneyStatus.budget == 0 {
                    BudgetSettingView(moneyStatus: moneyStatus)
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                    TabView(selection: $selectedTab) {
                        HomeView(moneyStatus: moneyStatus, selectedTab: $selectedTab)
                            .tabItem {
                                Label("홈", systemImage: "house.fill")
                            }
                            .tag(0)
                        CalendarView()
                            .tabItem {
                                Label("달력", systemImage: "calendar")
                            }
                            .tag(1)
                        SlotView()
                            .tabItem {
                                Label("오늘 뭐 먹지?", systemImage: "fork.knife")
                            }
                            .tag(2)
                    }
                    .accentColor(.green)
                    .navigationBarTitleDisplayMode(.inline)
                }
            } else {
                Text("데이터를 불러오는 중...")
                    .onAppear {
                        addInitialMoneyStatus()
                    }
            }
        }
    }
    
    private func addInitialMoneyStatus() {
        let newMoneyStatus = MoneyStatus(date: Date(), amount: [], budget: 0, targetTime: 1)
        modelContext.insert(newMoneyStatus)
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var moneyStatus: MoneyStatus
    @State private var tempBudget: String = ""
    @Binding var selectedTab: Int
    @State private var showAddTransactionView = false
    
    var body: some View {
        VStack {
            if moneyStatus.budget == 0 {
                BudgetSettingView(moneyStatus: moneyStatus)
            } else {
                HStack {
                    Spacer()
                    NavigationLink(destination: UpdateBudgetView(moneyStatus: moneyStatus)) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.green)
                    }
                }
                Image("JJalang")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                HStack {
                    Text(moneyStatus.formattedDate)
                    Text(" ~ ")
                    Text(moneyStatus.formattedperiodTime)
                }
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: progressPercentage())
                        .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow, .green]), center: .center), lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 200, height: 200)
                        .animation(.easeInOut(duration: 1), value: moneyStatus.filteredAmount)
                    
                    VStack {
                        Text("사용 금액")
                            .font(.headline)
                        Text("₩ \(moneyStatus.filteredAmount.reduce(0) { $0 + $1.amount })")
                            .font(.title)
                            .bold()
                            .padding(.top, 10)
                    }
                    .navigationDestination(isPresented: $showAddTransactionView) {
                        AddTransactionView(moneyStatus: moneyStatus, selectedTab: $selectedTab)
                    }
                    Spacer()
                }
                .padding()
                Text("/ ₩ \(moneyStatus.budget)")
                    .foregroundColor(.gray)
                Spacer()
                Text(budgetMessage)
                    .font(.headline)
                    .foregroundColor(budgetMessageColor)
                    .padding()
                Button(action: {
                    showAddTransactionView = true
                }) {
                    Text("지출 추가")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
    }
    
    
    func progressPercentage() -> CGFloat {
        // 특정 기간 내의 지출만 합산하여 반영
        let filteredSpent = moneyStatus.filteredAmount.reduce(0) { $0 + $1.amount }
        print(Double(filteredSpent) / Double(moneyStatus.budget))
        return CGFloat(filteredSpent) / CGFloat(moneyStatus.budget)
    }
    // guard moneyStatus.budget > 0 else { return 0 }
    private var budgetMessage: String {
        let filteredSpent = moneyStatus.filteredAmount.reduce(0) { $0 + $1.amount }
        let percentage = Double(filteredSpent) / Double(moneyStatus.budget)
        switch percentage {
        case let x where x > 1.0:
            return "예산을 초과했어요."
        case let x where x == 1.0:
            return "예산을 모두 사용했어요."
        case let x where x >= 0.8:
            return "예산의 80% 이상을 사용했어요."
        case let x where x >= 0.5:
            return "예산의 절반 이상을 사용했어요"
        default:
            return " "
        }
        
    }
    
    private var budgetMessageColor: Color {
        let filteredSpent = moneyStatus.filteredAmount.reduce(0) { $0 + $1.amount }
        let percentage = Double(filteredSpent) / Double(moneyStatus.budget)
        switch percentage {
        case let x where x < 0.5:
            return .green
        case let x where x < 0.8:
            return .orange
        default:
            return .red
        }
    }
}
#Preview {
    ContentView()
        .modelContainer(for: [MoneyStatus.self], inMemory: true)
}
