//
//  AchievementRowView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 01.05.2026.
//

import SwiftUI

struct AchievementRowView: View {

    let achievement: Achievement

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(achievement.iconColor)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: achievement.icon)
                        .foregroundStyle(.white)
                        .font(.footnote)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.title)
                    .font(.headline)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 4)

            Spacer()

            Image(systemName: achievement.isAchieved ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(achievement.isAchieved ? .green : Color(.tertiaryLabel))
                .font(.title2)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 0) {
        AchievementRowView(achievement: Achievement(
            icon: "trophy.fill", iconColor: .orange,
            title: "Centurion", description: "Complete 100 tasks", isAchieved: true
        ))
        Divider().padding(.leading, 56)
        AchievementRowView(achievement: Achievement(
            icon: "star.fill", iconColor: .cyan,
            title: "Fresh focused", description: "Complete your first focus session", isAchieved: false
        ))
    }
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 14))
    .padding()
    .background(Color(.systemGroupedBackground))
}
