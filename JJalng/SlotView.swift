import SwiftUI
import SwiftData

enum MenuItem: String, CaseIterable {
    case pizza = "🍕 피자"
    case burger = "🍔 버거"
    case sushi = "🍣 초밥"
    case ramen = "🍜 라면"
    case salad = "🥗 샐러드"
    case bread = "🍞 빵"
    case steak = "🥩 스테이크"
    case tempura = "🍤 튀김"
    case curry = "🍛 카레"
    case sandwich = "🥪 샌드위치"
    case hotdog = "🌭 핫도그"
    case dumplings = "🥟 만두"
    case rice = "🍚 백반"
    case chicken = "🍗 치킨"
    case stew = "🥘 찌개"
    case jeongol = "🍲 전골"
    case samgyeopsal = "🥓 삼겹살"
    case galbi = "🍖 갈비"
    case fishcake = "🍢 어묵"
    case triangleRiceBall = "🍙 삼각김밥"
    case pasta = "🍝 파스타"
    case friedEgg = "🍳 계란프라이"
    case stirfriedSquid = "🦑 오징어볶음"
    case sashimi = "🐟 회"
    case pho = "🍜 쌀국수"
    case seafoodSoup = "🦐 해물탕"
    
    var price: Int {
        switch self {
        case .pizza:
            return 18000
        case .burger:
            return 9000
        case .sushi:
            return 22000
        case .ramen:
            return 9000
        case .salad:
            return 7000
        case .bread:
            return 4000
        case .steak:
            return 35000
        case .tempura:
            return 12000
        case .curry:
            return 9000
        case .sandwich:
            return 7500
        case .hotdog:
            return 5000
        case .dumplings:
            return 7000
        case .rice:
            return 6000
        case .chicken:
            return 20000
        case .stew:
            return 11000
        case .jeongol:
            return 18000
        case .samgyeopsal:
            return 17000
        case .galbi:
            return 25000
        case .fishcake:
            return 15000
        case .triangleRiceBall:
            return 1800
        case .pasta:
            return 14000
        case .friedEgg:
            return 2500
        case .stirfriedSquid:
            return 15000
        case .sashimi:
            return 30000
        case .pho:
            return 10000
        case .seafoodSoup:
            return 18000
        }
        
    }
    
    // 메뉴 이름을 반환하는 computed property
    var name: String {
        return self.rawValue
    }
    
    // 비싼 음식인지 확인하는 computed property
    var isExpensive: Bool {
        return price >= 12000  // 예: 12000원 이상이면 비싼 음식
    }
    
    // 저렴한 음식인지 확인하는 computed property
    var isCheap: Bool {
        return price < 12000  // 예: 12000원 미만이면 저렴한 음식
    }
}

// 슬롯 머신 메인 뷰 구조체
struct SlotView: View {
    private let items: [MenuItem] = MenuItem.allCases  // enum을 사용하여 아이템 리스트 생성
    
    @State private var selectedItem: MenuItem?         // 선택된 아이템을 추적할 상태 변수
    @State private var offsets: [CGFloat] = [0]        // 오프셋 상태 변수 (스크롤 위치)
    @State private var isSpinning = false              // 스핀 중인지 확인하는 상태 변수
    private let itemHeight: CGFloat = 200              // 각 아이템의 높이
    private let spinDuration: Double = 1.5             // 스핀 애니메이션 지속 시간
    private var maxSpinOffset: CGFloat                 // 최대 스핀 오프셋 (스크롤 거리)
    @Environment(\.modelContext) private var modelContext
    @Query private var moneyStatusList: [MoneyStatus]
    let moneyStatus: MoneyStatus
    
    init(moneyStatus: MoneyStatus) {
        self.moneyStatus = moneyStatus
        self.maxSpinOffset = CGFloat(items.count) * itemHeight
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 제목
            Text("오늘의 랜덤 메뉴는?")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Color(.black))
                .background(Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .frame(height: 10)
                    .offset(y: 20)
                )
            
            Text("오늘의 메뉴: \(selectedItem?.name ?? " ") \(selectedItem?.price ?? 0) 원")
                .font(.headline)
                .padding()
            
            reelsView
            spinButton
            
            VStack {
                Text("남은 예산이...")
                HStack {
                    Text("\(moneyStatus.remainingBudget)")
                        .fontWeight(.bold)
                    Text("원")
                }
            }
            .padding(.top, 80)
        }
        .padding()
    }
    
    // 릴(reel) 뷰 생성
    private var reelsView: some View {
        HStack(spacing: 50) {
            ForEach(0..<1) { index in
                PickerReel(
                    items: items.map { $0.name },  // items 배열을 텍스트 배열로 변환
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
            Text("Let's go")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 200)
                .cornerRadius(10)
                .background( RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [ Color.green.opacity(0.3), Color.green.opacity(0.7),Color.green.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                )
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
            selectedItem = MenuItem.allCases[finalIndex]
            isSpinning = false
        }
    }
    
    // 가장 가까운 아이템으로 조정하는 함수
    func NearItem() -> Int {
        var finalIndex: Int = 0
        
        withAnimation(.interactiveSpring()) {
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
    let items: [String]               // 표시할 아이템 배열 (이제 String 배열)
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
                    .background(Color(hue: Double(i % items.count) / Double(items.count), saturation: 0.3, brightness: 0.95))
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 2))
            }
        }
        .offset(y: offset)
        .frame(height: itemHeight)
        .clipped()  // 넘어가는 부분 잘라줌.
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}
