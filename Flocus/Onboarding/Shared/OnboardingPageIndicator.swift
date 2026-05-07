//
//  OnboardingPageIndicator.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 07.05.2026.
//

import SwiftUI

struct OnboardingPageIndicator: View {
    let totalPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                if index == currentPage {
                    Capsule()
                        .fill(Color(red: 0.25, green: 0.47, blue: 0.85))
                        .frame(width: 28, height: 8)
                } else {
                    Circle()
                        .fill(Color(red: 0.75, green: 0.76, blue: 0.78))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

#Preview {
    OnboardingPageIndicator(totalPages: 4, currentPage: 1)
}
