//
//  StatCardView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 30.04.2026.
//

import SwiftUI

struct StatCardView: View {
      let icon: String
      let iconColor: Color
      let title: String
      let value: String
      let subtitle: String

      var body: some View {
          VStack(alignment: .leading, spacing: 8) {
              HStack {
                  RoundedRectangle(cornerRadius: 8)
                      .fill(iconColor)
                      .frame(width: 32, height: 32)
                      .overlay(
                          Image(systemName: icon)
                              .foregroundStyle(.white)
                              .font(.footnote)
                      )
                  Text(title)
                      .font(.subheadline)
                      .foregroundStyle(.secondary)
              }
              Text(value)
                  .font(.title2).bold()
              Text(subtitle)
                  .font(.caption)
                  .foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 14))
      }
  }


#Preview {
    StatCardView(
        icon: "clock.fill",
        iconColor: .blue,
        title: "Focus time",
        value: "48h 25m",
        subtitle: "this month"
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
