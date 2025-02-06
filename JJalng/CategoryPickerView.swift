//
//  CategoryPickerView.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/6/25.
//

import SwiftUI

struct CategoryPickerView: View {
    let categories: [String]
    @Binding var selectedCategory: String
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("카테고리")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button(action: {
                withAnimation { isExpanded.toggle() }
            }) {
                HStack {
                    Text(selectedCategory.isEmpty ? "카테고리 선택" : selectedCategory)
                        .font(.headline)
                        .foregroundColor(selectedCategory.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
            }

            if isExpanded {
                VStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            withAnimation { isExpanded = false }
                        }) {
                            HStack {
                                Text(category)
                                    .foregroundColor(.black)
                                Spacer()
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                        }
                    }
                }
                .padding(.top, 5)
            }
        }
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    @State static var selectedCategory = ""
    static var previews: some View {
        CategoryPickerView(categories: ["🍽️ 식비", "🚗 교통", "🛍 쇼핑", "🎮 여가", "💰 저축", "📂 기타"],
                           selectedCategory: $selectedCategory)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
