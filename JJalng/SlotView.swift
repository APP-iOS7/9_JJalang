//
//  SlotView.swift
//  JJalng
//
//  Created by 김동영 on 2/4/25.
//

import SwiftUI

// 슬롯 머신 메인 뷰 구조체
struct SlotView: View {
    private let items: [String] = [
        // "산다","안 산다","산다","안 산다","산다","안 산다","산다","안 산다",
        "🍕 피자", "🍔 버거", "🍣 초밥", "🍜 라면", "🥗 샐러드", "🍞 빵", "🥩 스테이크", "🍤 튀김", "🍛 카레", "🥪 샌드위치", "🌭 핫도그", "🥟 만두", "🍚 백반", "🍗 치킨", "🥘 찌개", "🍲 전골", "🥓 삼겹살", "🍖 갈비", "🍢 어묵", "🍙 삼각김밥", "🍝 파스타", "🍳 계란프라이", "🦑 오징어볶음", "🐟 회", "🍜 쌀국수", "🦐 해물탕"]
    
    init() {
        self.maxSpinOffset = CGFloat(items.count) * itemHeight
    }

    @State private var selectedItem: String?        // 선택된 아이템을 추적할 상태 변수
    @State private var offsets: [CGFloat] = [0]     // 오프셋 상태 변수 (스크롤 위치)
    @State private var isSpinning = false           // 스핀 중인지 확인하는 상태 변수
    private let itemHeight: CGFloat = 200           // 각 아이템의 높이
    private let spinDuration: Double = 1.5          // 스핀 애니메이션 지속 시간
    private var maxSpinOffset: CGFloat              // 최대 스핀 오프셋 (스크롤 거리)
    
    var body: some View {
        VStack(spacing: 20) {
            // 선택된 아이템 표시
            if let selected = selectedItem {
                Text("선택된 아이템: \(selected)")
                    .font(.headline)
                    .padding()
            } else {
                Text(" ")
                    .font(.headline)
                    .padding()
            }
            reelsView
            spinButton
        }
        .padding()
    }
    
    // 릴(reel) 뷰 생성
    private var reelsView: some View {
        HStack(spacing: 50) {
            ForEach(0..<1) { index in
                PickerReel(
                    items: items,
                    offset: offsets[index],
                    itemHeight: itemHeight,
                    maxSpinOffset: maxSpinOffset
                )
            }
        }
    }
    
    // 스핀 버튼 뷰
    private var spinButton: some View {
        Button(action: spin) {
            Text("스핀")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 200)
                .background(isSpinning ? .gray : .red)
                .cornerRadius(10)
        }
        // 스핀 중 버튼 비활성화
        .disabled(isSpinning)
    }
    
    func spin() {
        isSpinning = true           // 스핀 상태 활성화
        selectedItem = nil          // 선택된 아이템 초기화
        // 랜덤한 오프셋 생성 (스크롤 거리)
        let randomOffset = CGFloat.random(in: -maxSpinOffset...(itemHeight * 2))
        // 스핀 애니메이션 적용
        withAnimation(.easeOut(duration: spinDuration)) {
            offsets = [randomOffset]
        }
        // 스핀 종료 후 처리
        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration) {
            let finalIndex = NearItem()
            selectedItem = items[finalIndex]
            isSpinning = false
        }
    }
    
    // 가장 가까운 아이템으로 조정하는 함수
    func NearItem() -> Int {
        var finalIndex: Int = 0
        
        withAnimation(.interactiveSpring()) {
            defer {
                print(finalIndex)
            }
            offsets = offsets.map { currentOffset in
                let centeringOffset = itemHeight / 2
                // 절대값의 음수 부호를 고려한 정확한 인덱스 계산
                finalIndex = Int(abs(currentOffset / itemHeight).rounded()) % items.count
                return -CGFloat(finalIndex) * itemHeight + centeringOffset - itemHeight
            }
        }
        return finalIndex
    }
}

struct PickerReel: View {
    let items: [String]               // 표시할 아이템 배열
    let offset: CGFloat               // 오프셋
    let itemHeight: CGFloat           // 각 아이템의 높이
    let maxSpinOffset: CGFloat        // 최대 스핀 오프셋

    // 반복 횟수 계산
    private var numberOfRepeats: Int {
        Int(maxSpinOffset / itemHeight) * 2
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 아이템 반복 표시
            ForEach(0..<numberOfRepeats, id: \.self) { i in
                Text(items[i % items.count])
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: 200, height: itemHeight)
            }
        }
        // .offset(x:y:)는 뷰를 지정한 x, y 좌표만큼 이동시키지만, 레이아웃에는 영향을 주지 않습니다.
        .offset(y: offset)
        .frame(height: itemHeight)
        .clipped()  // 넘어가는 부분 잘라줌.
        .background(
            Color.gray
                .opacity(0.2)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 2))
        )
    }
}


#Preview {
    SlotView()
}
