//
//  ExpenseCategoryView.swift
//  JJalang
//
//  Created by vKv on 2/4/25.
//

import SwiftUI

// 뷰 정의
struct ExpenseCategoryView: View {
    // 카테고리 배열: 각 카테고리에 이모티콘을 추가
    let categories = [
        "🍽️ 식비",
        "🚗 교통",
        "🛍 쇼핑",
        "🎮 여가",
        "💰 저축",
        "📂 기타"
    ]
    
    // 상태 변수: 사용자가 선택한 카테고리를 저장
    @State private var selectedCategory: String = "🍽️ 식비" // 초기값은 "식비"로 설정
    
    var body: some View {
        VStack(spacing: 20) {
            // 상단 제목
            Text("지출 항목 선택")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 20)
            
            // 카테고리 버튼 그리드 형식으로 배치
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                // 각 카테고리를 반복 처리
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        VStack {
                            Text(category.prefix(2))
                                .font(.system(size: 50))
                            
                            Text(category.dropFirst(2))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: 120, height: 120)
                        .background( 
                            selectedCategory == category ? Color.blue : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
            }
            .padding()
            
            // 선택된 항목 표시
            Text("지출 항목: \(selectedCategory)")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
        }
//        .background(Color.black.edgesIgnoringSafeArea(.all)) // 전체 배경 검정 설정
    }
}

#Preview {
    ExpenseCategoryView()
}
