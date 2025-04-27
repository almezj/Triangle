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
    private let placeholderCharacter1 = CharacterData(
        eyeCosmetic: EyeCosmetic(
            cosmeticId: 2,
            assetName: "ec_8bit_sunglasses",
            cosmeticTitle: "Sunglasses",
            relativeScale: 0.645,
            offsetXRatio: 0,
            offsetYRatio: 0.02,
            rotation: 0,
            price: 10
        ),
        headCosmetic: HeadCosmetic(
            cosmeticId: 2,
            assetName: "hc_wizard_hat",
            cosmeticTitle: "Wizard Hat",
            relativeScale: 0.48,
            offsetXRatio: 0,
            offsetYRatio: -0.32,
            rotation: 0,
            price: 0
        ),
        colorId: 1
    )
    
    private let placeholderCharacter2 = CharacterData(
        eyeCosmetic: EyeCosmetic.defaultCosmetic,
        headCosmetic: HeadCosmetic(
            cosmeticId: 2,
            assetName: "hc_beanie",
            cosmeticTitle: "Beanie",
            relativeScale: 0.45,
            offsetXRatio: 0,
            offsetYRatio: -0.25,
            rotation: 0,
            price: 10
        ),
        colorId: 1
    )
    private let placeholderCharacter3 = CharacterData(
        eyeCosmetic: EyeCosmetic(
            cosmeticId: 5,
            assetName: "ec_heart_sunglasses",
            cosmeticTitle: "Heart Sunglasses",
            relativeScale: 0.645,
            offsetXRatio: 0,
            offsetYRatio: -0.005,
            rotation: 0,
            price: 0
        ),
        headCosmetic: HeadCosmetic.defaultCosmetic,
        colorId: 1
    )
    
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
                                },
                                isNewButton: false
                            )
                        }
                        
                        // Example family profiles with unique character instances
                        ProfileButton(
                            username: "Jimmy",
                            character: placeholderCharacter1,
                            buttonSize: buttonSize,
                            action: {},
                            isNewButton: false
                        )
                        
                        ProfileButton(
                            username: "Chloe",
                            character: placeholderCharacter2,
                            buttonSize: buttonSize,
                            action: {},
                            isNewButton: false
                        )
                        ProfileButton(
                            username: "Mom",
                            character: placeholderCharacter3,
                            buttonSize: buttonSize,
                            action: {},
                            isNewButton: false
                        )
                        
                        // New profile button
                        ProfileButton(
                            username: "New",
                            character: nil,
                            buttonSize: buttonSize,
                            action: {
                                print("Create new profile tapped")
                            },
                            isNewButton: true
                        )
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
    let isNewButton: Bool
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: buttonSize * 0.05) {
                if isNewButton {
                    ZStack {
                        Image("add_new_character")
                            .resizable()
                            .frame(width: buttonSize * 0.75, height: buttonSize * 0.7)
                            .foregroundColor(ColorTheme.text)
                    }
                    .frame(height: buttonSize)
                } else if let character = character {
                    Character(characterData: character, useAnimations: true)
                        .frame(height: buttonSize)
                }
                
                Text(username)
                    .font(.profileName)
                    .foregroundColor(ColorTheme.text)
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
