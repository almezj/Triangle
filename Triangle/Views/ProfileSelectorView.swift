import SwiftUI

struct ProfileSelectorView: View {
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var isAnimating = false
    @Binding var showProfileSelector: Bool
    
    // 2x2 Grid layout
    let columns = [
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40)
    ]
    
    // Create unique character instances for placeholder profiles
    private let placeholderCharacter1 = CharacterData.defaultCharacter
    private let placeholderCharacter2 = CharacterData.defaultCharacter
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let buttonSize = min(size / 2, 340)
            
            ZStack {
                ColorTheme.background
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Who is learning today?")
                        .font(.pageTitle)
                        .foregroundColor(ColorTheme.text)
                        .padding(.bottom, size * 0.1)
                        .minimumScaleFactor(0.5)
                    
                    LazyVGrid(columns: columns, spacing: size * 0.05) {
                        // Current user profile button
                        if let currentUser = authManager.currentUserId,
                           let userData = userDataStore.userData {
                            ProfileButton(
                                username: currentUser,
                                character: userData.character,
                                buttonSize: buttonSize,
                                action: {
                                    withAnimation {
                                        showProfileSelector = false
                                    }
                                }
                            )
                        }
                        
                        // Example family profiles with unique character instances
                        ProfileButton(
                            username: "John",
                            character: placeholderCharacter1,
                            buttonSize: buttonSize,
                            action: {}
                        )
                        
                        ProfileButton(
                            username: "Dad",
                            character: placeholderCharacter2,
                            buttonSize: buttonSize,
                            action: {}
                        )
                        
                        // New profile button
                        Button(action: {
                            print("Create new profile tapped")
                        }) {
                            VStack(spacing: buttonSize * 0.05) {
                                ZStack {
                                    Image("add_new_character")
                                        .resizable()
                                        .frame(width: buttonSize * 0.75, height: buttonSize * 0.7)
                                        .foregroundColor(ColorTheme.text)
                                }
                                
                                Text("New")
                                    .font(.buttonText)
                                    .foregroundColor(ColorTheme.text)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, size * 0.05)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProfileButton: View {
    let username: String
    let character: CharacterData?
    let buttonSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: buttonSize * 0.05) {
                if let character = character {
                    Character(characterData: character, useAnimations: true)
                        .frame(height: buttonSize)
                }
                
                Text(username)
                    .font(.buttonText)
                    .foregroundColor(ColorTheme.text)
                    .minimumScaleFactor(0.5)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileSelectorView(showProfileSelector: .constant(true))
        .environmentObject(UserDataStore(userId: "guest"))
        .environmentObject(AuthenticationManager())
} 
