//
//  SlotView.swift
//  JJalng
//
//  Created by 김동영 on 2/4/25.
//

import SwiftUI

struct SlotView: View {
    let items: [String]
    @State private var offsets: [CGFloat] = [0]
    @State private var isSpinning = false
    let itemHeight: CGFloat = 100
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(0..<1) { index in
                    PickerReel(items: items, offset: $offsets[index], itemHeight: itemHeight)
                }
            }
            
            Button(action: spin) {
                Text("SPIN")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSpinning ? .gray : .red)
                    )
            }
            .disabled(isSpinning)
        }
    }
    
    func spin() {
        isSpinning = true
        
        withAnimation(.easeOut(duration: 2)) {
            offsets = offsets.map { _ in
                CGFloat.random(in: -5000...(-1000))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSpinning = false
            adjustToNearestItem()
        }
    }
    
    func adjustToNearestItem() {
        offsets = offsets.map { offset in
            let remainder = offset.truncatingRemainder(dividingBy: itemHeight)
            let adjustment = remainder > -itemHeight / 2 ? -remainder : (-itemHeight - remainder)
            return offset + adjustment
        }
    }
}

struct PickerReel: View {
    let items: [String]
    @Binding var offset: CGFloat
    let itemHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<100) { i in
                Text(items[i % items.count])
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 200, height: itemHeight)
            }
        }
        .offset(y: offset)
        .frame(height: itemHeight)
        .clipped()
        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black, .clear]),
                             startPoint: .top,
                             endPoint: .bottom))
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    SlotView(items: ["a", "b", "c", "d", "e"])
}
