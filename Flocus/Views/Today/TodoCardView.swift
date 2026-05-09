//
//  TodoCardView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 09.05.2026.
//

import SwiftUI

struct TodoCardView: View {
    let tasks: [TaskModel]
    let streak: Int

    private var total: Int { tasks.count }
    private var completed: Int { tasks.filter { $0.isCompleted }.count }
    private var progress: Double { total == 0 ? 0 : Double(completed) / Double(total) }

    private var dateString: String {
        Date.now.formatted(.dateTime.weekday(.wide).month().day())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dateString)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(completed)")
                            .font(.system(size: 48, weight: .bold))
                        Text("/ \(total)")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                    Text("tasks done today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if streak > 0 {
                    Label("\(streak)-day streak", systemImage: "flame.fill")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.15), in: Capsule())
                }
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.2))
                Capsule()
                    .fill(Color.blue)
                    .scaleEffect(x: progress, anchor: .leading)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
            .frame(height: 6)
            .clipped()
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        VStack(spacing: 16) {
            TodoCardView(
                tasks: [
                    TaskModel(title: "Buy groceries", details: "", dueDate: Date(), isCompleted: true),
                    TaskModel(title: "Finish report", details: "", dueDate: Date()),
                    TaskModel(title: "Read Swift docs", details: "", dueDate: Date()),
                ],
                streak: 12
            )
            TodoCardView(tasks: [], streak: 0)
        }
        .padding()
    }
}
