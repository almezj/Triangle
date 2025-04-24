//
//  ProfileView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileController = ProfileController()
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavigationBar(
                    title: authManager.currentUserId ?? "Profile", onBack: nil)
                VStack {
                    Character(characterData: userDataStore.userData?.character ?? CharacterData.defaultCharacter, useAnimations: true)
                        .frame(height: 500)
                        .padding()
                    NavigationLink(
                        destination: InventoryView()
                    ) {
                        Text("Customise")
                            .font(.pageTitle)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    NavigationLink(
                        destination: SettingsView(userDataStore: userDataStore)
                    ) {
                        Text("Settings")
                            .font(.pageTitle)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding()
                .frame(maxHeight: .infinity)
                .background(ColorTheme.background)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        return ProfileView()
            .environmentObject(UserDataStore(userId: "guest"))
            .environmentObject(AuthenticationManager())
    }
}
