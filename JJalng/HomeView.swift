//
//  HomeView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var moneyStatus: MoneyStatus
    @State private var tempBudget: String = ""
    @Binding var selectedTab: Int
    @State private var showAddTransactionView = false
<<<<<<< HEAD
    @State private var isVisible = true
=======
    @State private var isVisible: Bool = false
>>>>>>> 4aa77cd (Fix: HomeView)
    
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
                    .padding(.trailing, 16)
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
                .fontWeight(.semibold)
                
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
                .padding([.top,.bottom], 40)
                HStack {
                    Text("\(moneyStatus.remainingBudget) ₩")
                    Text("/ \(moneyStatus.budget) ₩")
                        .foregroundColor(.gray)
                }
                VStack {
                    Text(budgetMessage)
                        .font(.headline)
                        .foregroundColor(budgetMessageColor)
                        .padding()
                        .opacity(isVisible ? 1 : 0)
                }
                .onAppear {
                    isVisible = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isVisible = false // 2초 후 Text 숨김
                        }
                    }
                }
                Spacer()
                Button(action: {
                    SoundManager.shared.playSound(sound: "JJalangSound")
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

