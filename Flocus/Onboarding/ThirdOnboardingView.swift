//
//  ThirdOnboardingView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 07.05.2026.
//

import SwiftUI

struct ThirdOnboardingView: View {
    @AppStorage("username") private var username = ""
    @State private var showNext = false
    @FocusState private var isFocused: Bool

    private var canContinue: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What should\nwe call you?")
                    .font(.largeTitle.bold())

                Text("We'll use this to greet you in the app. Stays on your phone.")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.56))
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 60)

            VStack(alignment: .leading, spacing: 8) {
                Text("YOUR NAME")
                    .font(.caption.bold())
                    .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.56))
                    .tracking(1)

                TextField("e.g. Alex", text: $username)
                    .font(.body)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(
                                isFocused
                                    ? Color(red: 0.25, green: 0.47, blue: 0.85)
                                    : Color(red: 0.88, green: 0.89, blue: 0.91),
                                lineWidth: isFocused ? 2 : 1
                            )
                    }
                    .focused($isFocused)

                Text("You can change this later in Settings.")
                    .font(.caption)
                    .foregroundStyle(Color(red: 0.55, green: 0.57, blue: 0.62))
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            Spacer()

            OnboardingPageIndicator(totalPages: 4, currentPage: 2)
                .padding(.bottom, 20)

            Button { withAnimation { showNext = true } } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        Color(red: 0.25, green: 0.47, blue: 0.85)
                            .opacity(canContinue ? 1 : 0.4)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .disabled(!canContinue)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .fullScreenCover(isPresented: $showNext) {
            FourthOnboardingView()
        }
    }
}

#Preview {
    ThirdOnboardingView()
}
