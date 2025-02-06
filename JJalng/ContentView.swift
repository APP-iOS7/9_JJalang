
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
                .padding()
                Spacer()
                Text("계획")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                HStack {
                    Text(moneyStatus.formattedDate)
                    Text(" ~ ")
                    Text(moneyStatus.formattedperiodTime)
                }
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: progressPercentage())
                        .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow, .green]), center: .center), lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 200, height: 200)
                        .animation(.easeInOut(duration: 1), value: moneyStatus.totalSpent)
                    
                    VStack {
                        Text("사용 금액")
                            .font(.headline)
                        Text("₩ \(moneyStatus.totalSpent)")
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
        return CGFloat(min(Double(moneyStatus.totalSpent) / Double(moneyStatus.budget), 1.0))
    }
    private var budgetMessage: String {
        let percentage = Double(moneyStatus.totalSpent) / Double(moneyStatus.budget)
        if percentage == 0 {
            return ""
        } else if percentage < 0.5 {
            return "예산의 절반 이하를 사용했어요"
        } else if percentage < 0.8 {
            return "예산의 절반 이상을 사용했어요"
        } else if percentage < 1.0 {
            return "예산의 80% 이상을 사용했어요"
        } else {
            return "예산을 초과했어요"
        }
    }
    private var budgetMessageColor: Color {
        let percentage = Double(moneyStatus.totalSpent) / Double(moneyStatus.budget)
        if percentage < 0.5 {
            return .green
        } else if percentage < 0.8 {
            return .orange
        } else {
            return .red
            
        }
    }
    #Preview {
        ContentView()
            .modelContainer(for: [MoneyStatus.self], inMemory: true)
    }
}
