//
//  FirstOnboardingView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 07.05.2026.
//

import SwiftUI

private struct AppLogoView: View {
    var size: CGFloat = 120

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.2237, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.42, green: 0.62, blue: 0.96),
                            Color(red: 0.25, green: 0.47, blue: 0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color(red: 0.25, green: 0.47, blue: 0.85).opacity(0.4), radius: 20, x: 0, y: 8)

            Image(systemName: "clock")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.52, height: size * 0.52)
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
    }
}



struct FirstOnboardingView: View {
    @State private var showNext = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            AppLogoView(size: 120)
                .padding(.bottom, 28)
            Text("Flocus")
                .font(.largeTitle.bold())
                .padding(.bottom, 4)
            Text("A quiet place for your tasks and\nfocus time.")
                .font(.title3)
                .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.56))
                .multilineTextAlignment(.center)

            Spacer()

            OnboardingPageIndicator(totalPages: 4, currentPage: 0)
                .padding(.bottom, 20)

            Button { withAnimation {
                showNext = true
            }
            } label: {
                Text("Get started")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.25, green: 0.47, blue: 0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            .fullScreenCover(isPresented: $showNext) {
                SecondOnboardingView()
            }
        }
    }
}

#Preview {
    FirstOnboardingView()
    
}
