//
//  MemoInputView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI

struct MemoInputView: View {
    let amount: String
    let category: String
    let date: Date
    
    @State private var memo: String = ""
    @Binding var selectedTab: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("메모입력")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 20)
            
            TextEditor(text: $memo)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
                // 메모 저장 로직
                UserDefaults.standard.set(memo, forKey: "userMemo")
                print("내용이 저장되었습니다: \(memo)")
                
                selectedTab = 0 // homeview로 이동
                dismiss() // 뷰 닫기
                
            }) {
                Text("추가")
//                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("메모 입력")
    }
}
#Preview {
    MemoInputView(amount: "10000", category: "🍽️식비", date: Date(), selectedTab: .constant(0))
}

