//
//  TopNavigationBar.swift
//  Triangle
//
//  Created by Josef Zemlicka on 25.02.2025.
//

import SwiftUI

struct TopNavigationBar: View {
    let title: String
    let onBack: (() -> Void)?

    @EnvironmentObject var userDataStore: UserDataStore

    var body: some View {
        ZStack {
            // Title
            Text(title)
                .font(.pageTitle)
                .foregroundColor(ColorTheme.text)

            // Left and Right controls
            HStack {
                if let onBack = onBack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(ColorTheme.text)
                    }
                    .padding(.leading, 16)
                } else {
                    Spacer().frame(width: 44)
                }

                Spacer()

                // Currency indicator
                ZStack {
                    Rectangle()
                        .frame(maxWidth: 130, maxHeight: 50)
                        .cornerRadius(30)
                        .foregroundColor(ColorTheme.accent)
                    HStack(spacing: 5) {
                        Text(
                            "\(userDataStore.userData?.inventory.currency ?? 0)"
                        )
                        .font(.shopCardTitle)
                        .fontWeight(.black)
                        .foregroundColor(ColorTheme.currencyColor)
                        .shadow(color: Color.black.opacity(0.6), radius: 3, x: 0, y: 0)
                        Image("currency_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .shadow(color: Color.black.opacity(0.6), radius: 2, x: 0, y: 0)
                    }
                    
                }
                .padding(.trailing, 16)
            }
        }
        .frame(height: 100)
        .background(ColorTheme.background)
    }
}

#Preview {
    Group {
        TopNavigationBar(title: "Page Title", onBack: {})
            .environmentObject(UserDataStore(userId: "guest"))
        TopNavigationBar(title: "Page Title", onBack: nil)
            .environmentObject(UserDataStore(userId: "guest"))
    }
}
