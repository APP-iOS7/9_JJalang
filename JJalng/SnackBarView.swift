//
//  SnackBarView.swift
//  JJalng
//
//  Created by 김동영 on 2/7/25.
//

import SwiftUI

struct SnackbarView: View {
    @State private var showSnackbar = false

    var body: some View {
        VStack {
            Spacer()
            
            Button("Show Snackbar") {
                withAnimation {
                    showSnackbar = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSnackbar = false
                    }
                }
            }
        }
        .overlay(
            VStack {
                if showSnackbar {
                    Text("예산을 입력하세요.")
                        .fontWeight(.bold)
                        .padding()
                        .frame(minWidth: 300, maxWidth: .infinity)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .opacity(showSnackbar ? 1 : 0)
                        .offset(y: showSnackbar ? 0 : 50)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showSnackbar)
                }
            }
            , alignment: .bottom
        )
    }
}

struct SnackbarView_Previews: PreviewProvider {
    static var previews: some View {
        SnackbarView()
    }
}
