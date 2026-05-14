//
//  SecondOnboardingView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 07.05.2026.
//

import SwiftUI

private struct FeatureBulletRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 0.88, green: 0.92, blue: 0.98))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color(red: 0.25, green: 0.47, blue: 0.85))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.bold())
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.56))
            }

            Spacer()
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color(red: 0.88, green: 0.89, blue: 0.91), lineWidth: 1)
        }
    }
}

struct SecondOnboardingView: View {
    @State private var showNext = false
    
    let testingID = UIIdentifiers.SecondOnboardingView.self

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("A calmer way\nto get things done.")
                    .font(.largeTitle.bold())

                Text("Three small ideas that make focus stick.")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.56))
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 60)

            VStack(spacing: 12) {
                FeatureBulletRow(
                    icon: "checkmark",
                    title: "Tiny task list",
                    subtitle: "Just today. No backlogs, no clutter."
                )
                FeatureBulletRow(
                    icon: "clock",
                    title: "Pomodoro built-in",
                    subtitle: "25-minute sprints. 5-minute breaks."
                )
                FeatureBulletRow(
                    icon: "iphone",
                    title: "Lives on your phone",
                    subtitle: "No accounts. No cloud. No nags."
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)

            Spacer()

            OnboardingPageIndicator(totalPages: 4, currentPage: 1)
                .padding(.bottom, 20)

            Button { withAnimation { showNext = true } } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.25, green: 0.47, blue: 0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .accessibilityIdentifier(testingID.continueButton)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .fullScreenCover(isPresented: $showNext) {
            ThirdOnboardingView()
        }
    }
}


#Preview {
    SecondOnboardingView()
}
