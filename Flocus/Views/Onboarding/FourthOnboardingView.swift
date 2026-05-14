//
//  FourthOnboardingView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 07.05.2026.
//

import SwiftUI

struct FourthOnboardingView: View {
    @AppStorage(UserDefaultsKeys.username) private var username = ""
    @AppStorage(UserDefaultsKeys.avatar) private var avatar = "avatar1"
    @AppStorage(UserDefaultsKeys.isOnboardingCompleted) var isOnboardingCompleted: Bool = false
    
    let testingID = UIIdentifiers.FourthOnboardingView.self

    private let avatars = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6"]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Pick a look,\n\(username).")
                    .font(.largeTitle.bold())

                Text("Choose an avatar for your profile.")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.56))
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 60)

            Image(avatar)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .padding(.top, 28)

            VStack(alignment: .leading, spacing: 10) {
                Text("AVATAR")
                    .font(.caption.bold())
                    .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.56))
                    .tracking(1)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(avatars, id: \.self) { name in
                        Button {
                            avatar = name
                        } label: {
                            Image(name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .strokeBorder(
                                            avatar == name
                                                ? Color(red: 0.25, green: 0.47, blue: 0.85)
                                                : Color.clear,
                                            lineWidth: 2.5
                                        )
                                        .padding(-4)
                                }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 28)

            Spacer()

            OnboardingPageIndicator(totalPages: 4, currentPage: 3)
                .padding(.bottom, 20)

            Button { withAnimation { isOnboardingCompleted = true }  } label: {
                Text("Start focusing")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.25, green: 0.47, blue: 0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .accessibilityIdentifier(testingID.startFocusButton)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    FourthOnboardingView()
}
