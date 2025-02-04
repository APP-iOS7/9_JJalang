//
//  MemoInputView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI

struct MemoInputView: View {
    @State private var memo: String = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $memo)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
                // 메모 저장 로직
                UserDefaults.standard.set(memo, forKey: "userMemo")
                print("메모가 저장되었습니다: \(memo)")
            }) {
                Text("메모 저장")
//                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("메모 입력")
    }
}
#Preview {
    MemoInputView()
}
