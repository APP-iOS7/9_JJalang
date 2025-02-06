
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
