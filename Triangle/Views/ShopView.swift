//
//  ShopView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 12.03.2025.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager
    @State var randomCosmetics: [any Cosmetic] = []

    var body: some View {
        NavigationStack {
            TopNavigationBar(title: "Shop", onBack: nil)
            VStack {
                Spacer()
                HStack{
                    ForEach(randomCosmetics, id: \.uniqueId) { cosmetic in
                        ShopCard(cosmetic: cosmetic, action: {(() -> Void).self})
                    }
                }
                Spacer()
                Button("Refresh Shop") {
                    print("Shop refreshed")
                    randomCosmetics = userDataStore.getRandomCosmetics()
                }
                .padding()
                .background(ColorTheme.primary)
                .foregroundColor(.white)
                .cornerRadius(8)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(ColorTheme.background)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .onAppear {
            randomCosmetics = userDataStore.getRandomCosmetics()
        }
    }
       
}

#Preview {
    ShopView()
        .environmentObject(UserDataStore(userId: "almezj"))
        .environmentObject(AuthenticationManager())
}
