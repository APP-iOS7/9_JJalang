
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
            } else {
                Text("데이터를 불러오는 중...")
                    .onAppear {
                        addInitialMoneyStatus()
                    }
            }
        }
    }
    
    private func addInitialMoneyStatus() {
        let newMoneyStatus = MoneyStatus(memo: "", date: Date(), amount: [], budget: 0, targetTime: 1)
        modelContext.insert(newMoneyStatus)
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    var moneyStatus: MoneyStatus
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
                Text(moneyStatus.periodTime.description)
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
                        Text("이번 달 사용 금액")
                            .font(.headline)
                        Text("₩ \(moneyStatus.totalSpent)")
                            .font(.title)
                            .bold()
                            .padding(.top, 10)
                    }
                    .navigationDestination(isPresented: $showAddTransactionView) {
                        AddTransactionView(selectedTab: $selectedTab)
                    }
                    Spacer()
                }
                .padding()
                Text("/ ₩ \(moneyStatus.budget)")
                    .foregroundColor(.gray)
                Spacer()
                
                Button(action: {
                    showAddTransactionView = true
                    //                    let newAmountInfo = AmountInfo(amount: 50000)
                    //                    moneyStatus.amount.append(newAmountInfo)
                    //                    try? modelContext.save()
                    
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
}

#Preview {
    ContentView()
        .modelContainer(for: [MoneyStatus.self], inMemory: true)
}
