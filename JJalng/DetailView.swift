//
//  SwiftUIView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/4/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var buyHistory: BuyHistory  // ✅ SwiftData와 연동되는 바인딩

    var body: some View {
        VStack {
            Text("지출 내역")
                .font(.title)
                .padding()
            
            Text("₩ \(buyHistory.memo)") // ✅ 금액이 아니라 메모가 표시되는 부분 수정
                .font(.largeTitle)
                .bold()
                .padding()

            // 폼 구성
            VStack(alignment: .leading, spacing: 20) {
                TextField("메모", text: $buyHistory.memo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("카테고리", text: Binding(
                    get: { buyHistory.category ?? "" },
                    set: { buyHistory.category = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                DatePicker("날짜", selection: Binding(
                    get: { buyHistory.date ?? Date() },
                    set: { buyHistory.date = $0 }
                ), displayedComponents: [.date])
                .padding()
            }
            .padding()

            // 저장 및 삭제 버튼
            HStack {
                Button(action: saveChanges) {
                    Text("저장")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)

                Button(action: deleteHistory) {
                    Text("삭제")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
        }
        .padding()
        .navigationBarTitle("지출 상세", displayMode: .inline)
    }
    
    // 변경사항 저장
    private func saveChanges() {
        try? modelContext.save() // ✅ SwiftData에 변경 사항 저장
    }
    
    // 지출 내역 삭제
    private func deleteHistory() {
        modelContext.delete(buyHistory) // ✅ SwiftData에서 삭제
        try? modelContext.save()
    }
}

//#Preview {
//    let container = try! ModelContainer(for: BuyHistory.self, inMemory: true)
//    let mockBuyHistory = BuyHistory(memo: "저녁식사", category: "식비", date: Date())
//    
//    container.mainContext.insert(mockBuyHistory)
//
//    return DetailView(buyHistory: mockBuyHistory)
//        .modelContainer(container)
//}
